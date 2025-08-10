

#' Date slider Widget
#'
#' @param id the server module id
#'
#' @return a ui object (output of fluidRow)
#' @export
#'
#' @examples
#' date_slider_widget(id = "mydata")


# -- INPUT: date slider
date_slider_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  fluidRow(
    column(width = 6, uiOutput(ns("date_slider_btn"))),
    column(width = 6, uiOutput(ns("date_slider_strategy_btn"))))

}
