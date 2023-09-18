

#' Title
#'
#' @param data.model
#'
#' @return
#' @export
#'
#' @examples


dm_filter <- function(data.model){

  # -- Check NULL & get names where filter TRUE
  if(!is.null(data.model))
    data.model[!data.model$filter, ]$name
  else
    NULL

}
