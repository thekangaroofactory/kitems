

#' Date sliderInput
#'
#' @param id the server module id
#'
#' @return a rendered sliderInput
#' @export
#'
#' @examples
#' date_slider_INPUT(id = "mydata")


# -- INPUT: date slider
date_slider_INPUT <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("date_slider"))

}
