

#' Title
#'
#' @param data.model
#'
#' @return
#' @export
#'
#' @examples


dm_default_val <- function(data.model){

  # -- extract
  data.model[!is.na(data.model$default_val)]$default_val

}