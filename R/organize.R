

#' Sort Items Grammar
#'
#' @description
#' Set or get sorting order.
#'
#' @param config the config list
#' @param item optional (see details), the name (id) of the item group
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
#' When `item` is set in the parent frame, then the attribute can be skipped
#' in the function call.
#'
#' @seealso [parent.frame()]
#'
#' @returns `organize` returns a config list and
#' `organized` returns a character string
#' @export
#'
#' @examples
#' \dontrun{
#' organize(config, item = "foo", sort = "date, desc(total)")
#' organize(config, item = "foo", sort = NULL)
#' }

organize <- function(config, item = get_context(), sort){
  config_item_sort(config, item, sort)}


#' @rdname organize
#' @export
organized <- function(config, item = get_context()){
  config_item_row_order(config, item)}
