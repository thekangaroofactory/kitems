

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

  # -- return
  tagList(

    # -- when all attributes are filtered #362
    conditionalPanel(
      condition = (paste0("document.getElementById(\"", ns("filtered_view"), "\").children.length==0")),
      p("All attributes are filtered, the table is empty.")),

    # -- the table
    DT::DTOutput(ns("filtered_view")))

}
