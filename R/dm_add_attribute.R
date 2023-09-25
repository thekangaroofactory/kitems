

#' Title
#'
#' @param data.model
#' @param name
#' @param type
#' @param default.val
#' @param default.fun
#' @param skip
#' @param filter
#'
#' @return
#' @export
#'
#' @examples


dm_add_attribute <- function(data.model, name, type, default.val = NA, default.fun = NA, skip = FALSE, filter = FALSE){

  cat("[dm_add_attribute] Add attribute to data model \n")

  # -- check for empty strings (data.frame would fail)
  if(identical(default.val, ""))
    default.val <- NA

  if(identical(default.fun, ""))
    default.fun <- NA

  # -- check for NULL
  if(is.null(skip))
    skip <- FALSE

  if(is.null(filter))
    filter <- FALSE

  # -- init attribute
  new_attribute <- data.frame(name = name,
                              type = type,
                              default.val = default.val,
                              default.fun = default.fun,
                              skip = skip,
                              filter = filter)

  # -- merge to data.model (return)
  data.model <- rbind(data.model, new_attribute)

}
