

#' Title
#'
#' @param data.model
#' @param filter
#'
#' @return
#' @export
#'
#' @examples


dm_filter_set <- function(data.model = dm, filter = input$filter_col){

  # -- Reset filter column & update
  data.model$filter <- FALSE
  data.model[match(filter, data.model$name), ]$filter <- TRUE

  # -- return
  data.model

}
