

#' Date Slider Widget
#'
#' @description
#' The date slider UI component to drive the date filter.
#'
#' @param id the server module id.
#' @param bootstrap optional, a character string for the Bootstrap major version (see details).
#'
#' @details
#' `bootstrap` has been added in version 0.8.0 to determine if `bslib::popover()` can be used
#' in the widget. The default is provided by `bslib::version_default()`, but there is no obvious
#' way to know - from the UI side - if the app uses shiny's default or bslib layouts.
#'
#' In case you are using shiny's layout (ex: `shiny::fluidPage()`), you should set the parameter
#' to `bootstrap = "3"`.
#'
#' @return An HTML component to include on UI side.
#' @export
#'
#' @examples
#' \dontrun{
#' date_slider_widget(id = "mydata")
#' }

date_slider_widget <- function(id, bootstrap = bslib::version_default()){

  # namespace
  ns <- NS(id)

  # -- wrapper
  tagList(

    div(
      style = "display: inline-block; vertical-align:middle; margin-right:40px;",
      sliderInput(inputId = ns("date_slider"),
                  label = "Date",
                  width = "300px",
                  min = Sys.Date(),
                  max = Sys.Date(),
                  value = c(Sys.Date(), Sys.Date()))),

    # check Bootstrap version
    # because bslib::popover requires Bootstrap 5
    if(bootstrap == "5")

      div(
        style = "display: inline-block; vertical-align:top;",
        gear <- bslib::popover(
          title = "Strategies",
          placement = "right",
          trigger = icon("gear"),
          radioButtons(inputId = ns("date_slider_strategy"),
                       label = "",
                       choices = c("this-year", "keep-range"),
                       selected = "this-year")))

    else

      # (most probably Bootstrap 3)
      div(
        style = "display: inline-block; vertical-align:middle;",
        radioButtons(inputId = ns("date_slider_strategy"),
                     label = "Strategy",
                     choices = c("this-year", "keep-range"),
                     selected = "this-year",
                     inline = TRUE)))

}
