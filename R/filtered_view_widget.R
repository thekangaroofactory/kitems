

#' Filtered View Widget
#'
#' @description
#' Creates an HTML container for the filtered item table.
#'
#' @param id the id of the module server instance.
#'
#' @return An HTML object (tagList) to include in the UI.
#' @export
#'
#' @examples
#' \dontrun{
#' filtered_view_widget(id = "mydata")
#' }

filtered_view_widget <- function(id){

  # -- namespace
  ns <- NS(id)

  # -- return
  tagList(

    # -- when all attributes are filtered #362
    conditionalPanel(
      condition = (paste0("document.getElementById(\"", ns("filtered_view"), "\").children.length==0")),
      p("All attributes are filtered, the table is empty.")),

    # -- the table
    DT::DTOutput(ns("filtered_view")))

}
