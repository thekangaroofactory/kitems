

#' Set data model attribute filter
#'
#' @param data.model a data.frame containing the data model
#' @param filter a character vector with the name of the attributes to be filtered
#'
#' @return an updated data model
#' @export
#'
#' @examples
#' \dontrun{
#' dm_filter_set(data.model = mydatamodel, filter = c("id", "internal"))
#' }


dm_filter_set <- function(data.model, filter){

  # -- Reset filters
  data.model$filter <- FALSE

  # -- Set filter
  if(!is.null(filter))
    data.model[match(filter, data.model$name), ]$filter <- TRUE

  # -- Return
  data.model

}
