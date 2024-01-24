

#' Extract filters from data model
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a named vector of the attribute filters
#' @export
#'
#' @examples
#' \dontrun{
#' dm_filter(data.model = mydatamodel)
#' }


dm_filter <- function(data.model){

  # -- Check NULL & get names where filter TRUE
  if(!is.null(data.model))
    data.model[data.model$filter, ]$name
  else
    NULL

}
