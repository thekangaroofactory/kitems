

#' Trigger Event
#'
#' @description
#' Helper function to create events to be passed to kitems module server
#' with the `trigger` argument.
#'
#' @param workflow the name of the workflow (create, update or delete).
#' @param type the name of the action to be performed (dialog or task).
#' @param values optional list of values to create, update or delete an item.
#'
#' @details
#' The function also adds an event id to make it unique (otherwise sending
#' two times the same request would fail).
#'
#' For more details see this vignette:
#' \code{vignette("workflows", package = "kitems")}
#'
#' @seealso [kitems()]
#'
#' @returns A list.
#' @export
#'
#' @examples
#' \dontrun{
#' # create dialog event
#' trigger_event()
#'
#' # delete item event (without dialog)
#' trigger_event(workflow = "delete", type = "task", values = list(id = 1234))
#' }

trigger_event <- function(workflow = c("create", "update", "delete"), type = c("dialog", "task"), values = NULL){

  # -- argument checks
  workflow <- match.arg(workflow)
  type <- match.arg(type)

  # -- check for when values should not be null
  if(is.null(values))
    if(!(workflow == "create" && type == "dialog"))
      stop("values should be passed for this type of event")

  # -- build default event
  # adding event_id to make event unique (otherwise reactive won't update)
  event <- list(
    event_id = ktools::uuid(),
    workflow = workflow,
    type = type)

  # return
  if(is.null(values)) event else append(event, list(values = values))

}
