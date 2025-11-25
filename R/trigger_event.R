

#' Trigger Event
#'
#' @description
#' Helper function to create events to be passed to kitems module server
#' with the `trigger` argument.
#'
#' @param workflow the name of the workflow (create, update or delete).
#' @param type the name of the action to be performed (dialog or task).
#' @param values optional values to create, update or delete an item.
#'
#' @returns An event object (list).
#' @export
#'
#' @examples
#' \dontrun{
#' # fire create dialog event
#' trigger_event()
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
  event <- list(
    workflow = workflow,
    type = type)

  # return
  if(is.null(values)) event else append(event, list(values = values))

}
