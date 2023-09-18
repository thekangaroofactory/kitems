

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
