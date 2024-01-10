

#' Title
#'
#' @param r
#'
#' @return
#' @export
#'
#' @examples


dm_get_list <- function(r){

  # -- Get data models from r
  values <- isolate(reactiveValuesToList(r))
  values <- names(values)
  values <- values[grep("data_model", values)]
  values <- strsplit(values, "data_model")

  # -- Return
  values

}
