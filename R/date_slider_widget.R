

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

    # -- slider input
    column(
      width = 6,
      sliderInput(inputId = ns("date_slider"),
                  label = "Date",
                  width = "300px",
                  min = Sys.Date(),
                  max = Sys.Date(),
                  value = c(Sys.Date(), Sys.Date()))),

    # -- strategies
    column(
      width = 6,
      radioButtons(inputId = ns("date_slider_strategy"),
                   label = "Strategy",
                   choices = c("this-year", "keep-range"),
                   selected = "this-year",
                   inline = TRUE)))

}
