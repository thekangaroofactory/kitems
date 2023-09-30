

#' Title
#'
#' @param data.model
#'
#' @return
#' @export
#'
#' @examples


dm_default_fun <- function(data.model){

  # -- Extract
  data.model[!is.na(data.model$default_fun)]$default_fun

}
