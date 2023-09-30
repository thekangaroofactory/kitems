

#' Title
#'
#' @param data.model
#'
#' @return
#' @export
#'
#' @examples


dm_skip <- function(data.model){

  # -- Check NULL & get names where filter TRUE
  if(!is.null(data.model))
    data.model[data.model$skip, ]$name
  else
    NULL

}
