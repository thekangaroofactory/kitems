

#' Filter Event
#'
#' @description
#' Helper function to create filter events to be passed to kitems module server
#' with the filter argument.
#'
#' @param layer the filter layer ("pre" or "main").
#' @param ... the expression(s) to pass to the filter.
#'
#' @returns A list.
#' @export
#'
#' @details
#' When no expression is passed to `...` then the filter layer will be reset.
#'
#' See the module server function to know how to pass the event to the module
#' server.
#'
#' For more details see this vignette:
#' \code{vignette("filtering", package = "kitems")}
#'
#' @seealso [kitems()]
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
