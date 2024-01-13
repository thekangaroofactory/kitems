

#' Title
#'
#' @param items
#' @param ns
#'
#' @return
#' @export
#'
#' @examples


input_date_slider <- function(items, ns){

  # -- define params
  min <- min(items$date)
  max <- max(items$date)
  value <- c(min(items$date), min(items$date) + 1)

  # -- build & renderinput
  renderUI(sliderInput(inputId = ns("date_slider"),
                       label = "Date",
                       min = min,
                       max = max,
                       value = value))

}
