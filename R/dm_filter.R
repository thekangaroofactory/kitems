

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

  # -- check data model
  if(is.null(data.model))
    return(NULL)

  # -- get names where filter TRUE
  x <- data.model[data.model$filter, ]$name

  # -- check (no filter in data model)
  if(identical(x, character(0)))
    x <- NULL

  # -- return
  return(x)

}
