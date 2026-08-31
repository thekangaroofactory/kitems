

#' Sort Items Grammar
#'
#' @description
#' Set or get sorting order.
#'
#' @param config the config list
#' @param item the name of the item
#' @param sort a character string to set the order (see details)
#'
#' @details
#' The `organize` function accepts a character string for `sort` because it is
#' primarily intended to deal with the Admin Console (which returns
#' a character string from the user input).
#'
#' Setting `sort = NULL` will reset the item sorting!
#'
#' Ranking depends on the position of the attribute.
#' Wrap attribute name by "desc()" to set descending order.
#'
#' @returns `organize` returns a config list and
#' `organization` returns a character string
#' @export
#'
#' @examples
#' \dontrun{
#' organize(config, item = "foo", sort = "date, desc(total)")
#' organize(config, item = "foo", sort = NULL)
#' }

organize <- function(config, item, sort){
  config_item_sort(config, item, sort)}


#' @rdname organize
#' @export
organization <- function(config, item){
  config_item_row_order(config, item)}
