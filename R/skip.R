

#' Skip Attribute Grammar
#'
#' @description
#' A set of verbs to manipulate the skipped attribute(s) of an item.
#'
#' @param config the config list
#' @param item the name (id) of the targeted item
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

skip <- function(config, item, ...){
  config_attribute_skip(config, item, ...)}

#' @rdname skip
#' @export
include <- function(config, item, ...){
  config_attribute_skip(config, item, ..., skip = FALSE)}

#' @rdname skip
#' @export
skipped <- function(config, item){
  config_attribute_skipped(config, item)}

#' @rdname skip
#' @export
included <- function(config, item){
  config_attributes(config, item)[!config_attributes(config, item) %in% config_attribute_skipped(config, item)]}
