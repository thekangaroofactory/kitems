

#' Reveal Items
#'
#' @description
#' Apply data model display mask on the items.
#'
#' @param items a data.frame of the items.
#' @param data.model a data.frame of the data model.
#'
#' @return A data.frame of the items with applied mask.
#' @export
#'
#' @details
#' The data model display mask is defined by attributes with display = `TRUE`.
#'
#' @examples
#' \dontrun{
#' item_reveal(items = "myitems", data.model = "mydatamodel")
#' }

item_reveal <- function(items, data.model){

  # -- Apply attribute display
  items[display(data.model)]

}
