

#' Skip Behavior Grammar
#'
#' @description
#' A set of verbs to manipulate the skipped attribute(s) of an item.
#'
#' @param config the config list
#' @param item optional (see details), the name (id) of the item group
#' @param ... the name of the attribute(s) to manipulate
#'
#' @details
#' `skip()` and `include()` are setter functions that allow to add or remove attributes from the skipped ones.
#' `skipped()` and `included()` are getter functions to quickly access the attributes
#' that are skipped or included in the item form.
#'
#' In a scenario where items are created programmatically, `included()` may be used
#' to determine what values can be sent to the trigger.
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
#' # skip attribute
#' config <- design(project = "test",
#' item = "foo") |>
#' extend(item = "foo", attribute = c(name = "date", type = "Date")) |>
#' skip(item = "foo", "date")
#'
#' # get skipped attributes
#' config |> skipped(item = "foo")
#'
#' # include attribute
#' config |> include(item = "foo", "date")
#'
#' # get included attributes
#' config |> included(item = "foo")

skip <- function(config, item = get_context(), ...){
  ca_behavior(config, item, behavior = "skip", ...)}

#' @rdname skip
#' @export
include <- function(config, item = get_context(), ...){
  ca_behavior(config, item, behavior = "skip", ..., set = FALSE)}

#' @rdname skip
#' @export
skipped <- function(config, item = get_context()){
  ci_behavior(config, item)}

#' @rdname skip
#' @export
included <- function(config, item = get_context()){
  c_attributes(config, item)[!c_attributes(config, item) %in% ci_behavior(config, item)]}
