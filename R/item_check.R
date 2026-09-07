

#' Check Items
#'
#' @param items the data.frame of the items
#' @param config the YAML config list
#' @param id the name of the item
#'
#' @details
#' It is expected that config is checked first using [config_check()].
#'
#' @returns a list
#' @export
#'
#' @examples
#' \dontrun{
#' item_check(items, config, "foo")
#'}

item_check <- function(items, config, id){

  # -- check args (basic)
  stopifnot("items must be a data.frame" = is.data.frame(items))
  stopifnot("config must be a list" = is.list(items))

  rc <- list()

  # -- columns
  if(!identical(names(items), c_attributes(config, id))){

    # extra columns
    if(!all(x <- names(items) %in% c_attributes(config, id)))
      rc <- c(rc, list(code = 1, type = "error",
                       message = paste("Column(s)", paste(names(items)[!x], collapse = ", "), "not in the data.model"),
                       missing = names(items)[x]))

    # missing columns
    if(any(x <- !c_attributes(config, id) %in% names(items)))
      rc <- c(rc, list(code = 2, type = "error",
                       message = paste("Attribute(s)", paste(c_attributes(config, id)[x], collapse = ", "), "not in the items"),
                       missing = c_attributes(config, id)[x]))}


  # -- classes
  # when POSIXct, two classes will be found
  # (so output is list instead of vector)
  if(is.list(items_classes <- sapply(items, class)))
    items_classes <- unlist(lapply(items_classes, "[[", 1))

  # exclude extra / missing columns
  ref_classes <- ci_classes(config, id)
  items_classes <- items_classes[names(items_classes) %in% names(ref_classes)]
  ref_classes <- ref_classes[names(ref_classes) %in% names(items_classes)]

  # do check
  if(!identical(items_classes, ref_classes)){
    x <- names(items_classes[which(items_classes != ref_classes)])
    if(length(x))
      rc <- c(rc, list(code = 3, type = "error",
                       message = paste("Column(s)", paste(x, collapse = ", "), "type not matching with the data.model")))}

  # -- return
  rc

}

