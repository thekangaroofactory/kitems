

#' Extract skipped attributes
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a vector containing the names of the attributes to skip (or NULL if data.model is NULL)
#' @export
#'
#' @examples
#' dm_skip(data.model = mydatamodel)


dm_skip <- function(data.model){

  # -- Check NULL & get names where filter TRUE
  if(!is.null(data.model))
    data.model[data.model$skip, ]$name
  else
    NULL

}
