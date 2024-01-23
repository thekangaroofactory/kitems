

#' Extract default values from data model
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a named vector of the attribute default values
#' @export
#'
#' @examples
#' dm_default_val(data.model = mydatamodel)


dm_default_val <- function(data.model){

  # -- Extract
  data.model[!is.na(data.model$default.val)]$default.val

}
