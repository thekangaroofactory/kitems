

#' Date Slider Widget
#'
#' @description
#' The date slider UI component to drive the date filter
#'
#' @param id the server module id.
#'
#' @return an HTML component to include on UI side.
#' @export
#'
#' @examples
#' \dontrun{
#' date_slider_widget(id = "mydata")
#' }

date_slider_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  tagList(

    # -- slider input
    div(
      style = "display: inline-block; vertical-align:middle; margin-right:40px;",
      sliderInput(inputId = ns("date_slider"),
                  label = "Date",
                  width = "300px",
                  min = Sys.Date(),
                  max = Sys.Date(),
                  value = c(Sys.Date(), Sys.Date()))),

    # -- strategies
    div(
      style = "display: inline-block; vertical-align:middle;",
      radioButtons(inputId = ns("date_slider_strategy"),
                   label = "Strategy",
                   choices = c("this-year", "keep-range"),
                   selected = "this-year",
                   inline = TRUE)))

}
