

#' Display Behavior Grammar
#'
#' @description
#' A set of verbs to manipulate the display of an attribute.
#'
#' @param config the config list
#' @param item the name (id) of the targeted item
#' @param ... the name of the attribute(s) to manipulate
#'
#' @details
#' `hide()` and `display()` are setter functions to tune attribute's behavior.
#' `hidden()` and `displayed()` are getter functions to quickly access the attributes
#' to hide or display in the item table.
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
#' # hidden attributes
#' config |> hidden(item = "foo")
#'
#' # display attribute
#' config |> display(item = "foo", "date")
#'
#' # displayed attributes
#' config |> displayed(item = "foo")

hide <- function(config, item, ...){
  config_attribute_behavior(config, item, behavior = "hide", ...)}

#' @rdname hide
#' @export
display <- function(config, item, ...){
  config_attribute_behavior(config, item, behavior = "hide", ..., set = FALSE)}

#' @rdname hide
#' @export
hidden <- function(config, item){
  config_item_behavior(config, item, behavior = "hide")}

#' @rdname hide
#' @export
displayed <- function(config, item){
  config_attributes(config, item)[!config_attributes(config, item) %in% config_item_behavior(config, item, behavior = "hide")]}
