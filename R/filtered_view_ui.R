

#' Filtered view
#'
#' @param id the id of the module server instance
#'
#' @return a rendered DT data table
#' @export
#'
#' @examples
#' filtered_view_ui(id = "mydata")

filtered_view_ui <- function(id){

  # -- namespace
  ns <- NS(id)

  # -- the table
  DT::DTOutput(ns("filtered_view"))

}
