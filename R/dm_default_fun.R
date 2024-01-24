

#' Extract default function from data model
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a named vector of the attribute default functions
#' @export
#'
#' @examples
#' \dontrun{
#' dm_default_fun(data.model = mydatamodel)
#' }


dm_default_fun <- function(data.model){

  # -- Extract
  data.model[!is.na(data.model$default.fun)]$default.fun

}
