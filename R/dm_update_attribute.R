

#' Title
#'
#' @param data.model
#' @param name
#' @param default.val
#' @param default.fun
#' @param filter
#' @param skip
#'
#' @return
#' @export
#'
#' @details
#' Updating attribute class is not supported by this function (as it requires data migration).
#'
#' Use of vector to update several attributes is supported as long as length of the different parameters
#' is either same as name or 1 (then all rows gets same value).
#'
#' @examples
#' Use of vector to update several attributes:
#' dm_update_attribute(data.model = dm, name = c("name","total") , default.val = c("test", 2), default.fun = NA, filter = FALSE, skip = TRUE)


dm_update_attribute <- function(data.model, name, default.val = NULL, default.fun = NULL, filter = FALSE, skip = FALSE){

  # -- update row
  data.model[match(name, data.model$name), ]$default.val <- default.val
  data.model[match(name, data.model$name), ]$default.fun <- default.fun
  data.model[match(name, data.model$name), ]$filter <- filter
  data.model[match(name, data.model$name), ]$skip <- skip

  # -- return
  data.model

}
