

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

    # columns in data.model
    if(!all(x <- names(items) %in% c_attributes(config, id)))
      rc <- c(rc, list(code = 1, type = "error",
                       message = paste("Column(s)", paste(names(items)[x], collapse = ", "), "not in the data.model"),
                       missing = names(items)[x]))

    # missing columns
    if(any(x <- !c_attributes(config, id) %in% names(items)))
      rc <- c(rc, list(code = 2, type = "error",
                       message = paste("Attribute(s)", paste(c_attributes(config, id)[x], collapse = ", "), "not in the items"),
                       missing = c_attributes(config, id)[x]))

  }

  # -- types

  # items classes
  # when POSIXct, two classes will be found
  if(is.list(items_classes <- sapply(items, class)))
    items_classes <- sapply(items_classes, "[[", 1)

  if(!identical(items_classes, ci_classes(config, id))){
    x <- names(items_classes[which(items_classes != ci_classes(config, id))])
    if(length(x))
      rc <- c(rc, list(code = 3, type = "error",
                       message = paste("Column(s)", paste(x, collapse = ", "), "type not matching with the data.model")))

  }

  # -- return
  rc

}

