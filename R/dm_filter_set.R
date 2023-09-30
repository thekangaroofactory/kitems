

#' Title
#'
#' @param data.model
#' @param filter
#'
#' @return
#' @export
#'
#' @examples


dm_filter_set <- function(data.model, filter){

  # -- Reset filters
  data.model$filter <- FALSE

  # -- Set filter
  if(!is.null(filter))
    data.model[match(filter, data.model$name), ]$filter <- TRUE

  # -- Return
  data.model

}
