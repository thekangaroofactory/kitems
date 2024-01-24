

#' Build date sliderInput
#'
#' @param items a data.frame of the items
#' @param ns the namespace function
#'
#' @return a rendered sliderInput
#' @export
#'
#' @details
#' The min and max values are set to the min() and max() of items$date
#'
#' @examples
#' \dontrun{
#' input_date_slider(items = myitems, ns = shiny::NS())
#' }


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
