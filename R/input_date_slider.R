

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
  if(dim(items)[1] != 0){

    min <- min(items$date)
    max <- max(items$date)

  } else {

    min <- as.Date(Sys.Date())
    max <- min

  }

  # -- build & renderinput
  renderUI(sliderInput(inputId = ns("date_slider"),
                       label = "Date",
                       min = min,
                       max = max,
                       value = c(min, max)))

}
