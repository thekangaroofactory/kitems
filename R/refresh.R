

#' Refresh Behavior Grammar
#'
#' @description
#' A set of verbs to manipulate the refreshed attribute(s) of an item.
#'
#' @param config the config list.
#' @param item optional (see details), the name (id) of the item group.
#' @param ... the name of the attribute(s) to manipulate.
#'
#' @details
#' `refresh()` and `freeze()` are setter functions that allow to add or remove attributes from the refreshed ones.
#' `refreshed()` and `frozen()` are getter functions to quickly access the skipped attributes
#' that are refreshed or not during an item update.
#'
#' Trying to refresh an attribute that is not skipped will be ignored without warning.
#'
#' When `item` is set in the parent frame, then the attribute can be skipped
#' in the function call.
#'
#' @seealso [parent.frame()]
#'
#' @returns a config list (setters) or a character vector (getters)
#' @export
#'
#' @examples
#' # refresh attribute
#' config <- design(project = "test",
#' item = "foo") |>
#' extend(item = "foo", attribute = c(name = "date", type = "Date")) |>
#' skip(item = "foo", "date") |>
#' refresh(item = "foo", "date")
#'
#' # refreshed attributes
#' config |> refreshed(item = "foo")
#'
#' # freeze attribute
#' config |> freeze(item = "foo", "date")
#'
#' # frozen attributes
#' config |> frozen(item = "foo")

refresh <- function(config, item = get_context(), ...){
  ca_behavior(config, item, behavior = "refresh", ...)}

#' @rdname refresh
#' @export
freeze <- function(config, item = get_context(), ...){
  ca_behavior(config, item, behavior = "refresh", ..., set = FALSE)}

#' @rdname refresh
#' @export
refreshed <- function(config, item = get_context()){
  ci_behavior(config, item, behavior = "refresh")}

#' @rdname refresh
#' @export
frozen <- function(config, item = get_context()){
  ci_behavior(config, item)[!ci_behavior(config, item) %in% ci_behavior(config, item, behavior = "refresh")]}
