

#' Create Filter Event
#'
#' @param layer the filter layer ("pre" or "main")
#' @param ... the expression(s) to pass to the filter
#'
#' @returns an event (list)
#' @export
#'
#' @description
#' Helper function to create filter events to be passed to kitems module server
#' with the filter argument.
#'
#' @details
#' When no expression is passed to ... then the filter layer will be reset
#'
#' @examples
#' \dontrun{
#' # set pre-filtering layer
#' filter_event(layer = "pre", expr = name == Banana)
#'
#' # reset main filter
#' filter_event(layer = "main")
#' }

filter_event <- function(layer = c("pre", "main"), ...){

  # -- argument checks
  layer <- match.arg(layer)

  # -- build event
  event <- list(
    layer = layer,
    expr = if(missing(...)) NULL else rlang::exprs(...))

  # return
  event

}
