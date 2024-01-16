

# -- INPUT: date slider
date_slider_INPUT <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("date_slider"))

}
