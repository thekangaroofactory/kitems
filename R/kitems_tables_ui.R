

#' Filtered view
#'
#' @param id the id of the module server instance
#'
#' @return a rendered DT data table
#' @export
#'
#' @examples
#' items_filtered_view_DT(id = "mydata")

items_filtered_view_DT <- function(id){

  # -- namespace
  ns <- NS(id)

  # -- the table
  DT::DTOutput(ns("filtered_view"))

}
