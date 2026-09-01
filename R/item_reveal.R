

#' Reveal Items
#'
#' @description
#' Apply data model display mask on the items.
#'
#' @param items the data.frame of the items.
#' @param config the config list.
#' @param item optional (see details), the name (id) of the item group.
#'
#' @details
#' The data model display mask is defined at the data.model level.
#' use [hide()] or [display()] to tune it.
#'
#' When `item` is set in the parent frame, then the attribute can be skipped
#' in the function call.
#'
#' @seealso [hide()][display()][parent.frame()]
#'
#' @return A data.frame.
#' @export
#'
#' @examples
#' \dontrun{
#' item <- "foo"
#' items |> item_reveal(config)
#' }

item_reveal <- function(items, config, item = get_context()){

  items[displayed(config, item)]

}
