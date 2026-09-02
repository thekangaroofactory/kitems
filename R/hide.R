

#' Display Behavior Grammar
#'
#' @description
#' A set of verbs to manipulate the display of an attribute.
#'
#' @param config the config list.
#' @param item optional (see details), the name (id) of the item group.
#' @param ... the name of the attribute(s) to manipulate.
#'
#' @details
#' `hide()` and `display()` are setter functions to tune attribute's behavior.
#' `hidden()` and `displayed()` are getter functions to quickly access the attributes
#' to hide or display in the item table.
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
#' # hide attribute
#' config <- design(project = "test",
#' item = "foo") |>
#' extend(item = "foo", attribute = c(name = "date", type = "Date")) |>
#' hide(item = "foo", "date")
#'
#' # allow skipping argument in following calls
#' item <- "foo"
#'
#' # hidden attributes
#' config |> hidden()
#'
#' # display attribute
#' config |> display("date")
#'
#' # displayed attributes
#' config |> displayed()

hide <- function(config, item = get_context(), ...){
  config_attribute_behavior(config, item, behavior = "hide", ...)}

#' @rdname hide
#' @export
display <- function(config, item = get_context(), ...){
  config_attribute_behavior(config, item, behavior = "hide", ..., set = FALSE)}

#' @rdname hide
#' @export
hidden <- function(config, item = get_context()){
  config_item_behavior(config, item, behavior = "hide")}

#' @rdname hide
#' @export
displayed <- function(config, item = get_context()){
  config_attributes(config, item)[!config_attributes(config, item) %in% config_item_behavior(config, item, behavior = "hide")]}
