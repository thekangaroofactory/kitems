

#' Available data models
#'
#' @param r the shared reactive communication object
#'
#' @return a vector with the names (ids) of the data models available in session
#'
#' @examples
#' \dontrun{
#' dm_get_list(r)
#' }


dm_get_list <- function(r){

  # -- Get data models from r
  values <- isolate(reactiveValuesToList(r))
  values <- names(values)
  values <- values[grep("_data_model", values)]
  values <- strsplit(values, "_data_model")

  # -- Return
  values

}
