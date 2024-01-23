

#' Title
#'
#' @param r
#'
#' @return
#'
#' @examples


dm_get_list <- function(r){

  # -- Get data models from r
  values <- isolate(reactiveValuesToList(r))
  values <- names(values)
  values <- values[grep("_data_model", values)]
  values <- strsplit(values, "_data_model")

  # -- Return
  values

}
