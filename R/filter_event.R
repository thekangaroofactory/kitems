

#' Create Filter Event
#'
#' @param layer the filter layer ("pre" or "main")
#' @param expr the expression(s) to pass to the filter
#'
#' @returns an event (list)
#' @export
#'
#' @description
#' Helper function to create filter events to be passed to kitems module server
#' with the filter argument.
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
