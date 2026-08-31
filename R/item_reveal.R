

#' Reveal Items
#'
#' @description
#' Apply data model display mask on the items.
#'
#' @param items the data.frame of the items.
#' @param config the config list.
#' @param item the name (id) of the item in the config.
#'
#' @details
#' The data model display mask is defined at the data.model level.
#' use [hide()] or [display()] to tune it.
#'
#' @seealso [hide()][display()]
#'
#' @return A data.frame.
#' @export
#'
#' @examples
#' \dontrun{
#' item_reveal(items, config, item = "foo")
#' }

item_reveal <- function(items, config, item = NULL){

  items[displayed(config, item)]

}
