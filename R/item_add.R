

#' Add item
#'
#' @param item an item data.frame to be added
#' @param items the reference! of the reactive value carrying the items
#' @param name an optional character string to display along with the notification (basically the name of the item)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' item_add(items = myitems, item = mynewitem, name = "myitem")
#' }

item_add <- function(items, item, name = NULL){

  # -- check items
  stopifnot("reactiveVal" %in% class(items))

  # -- rbind & store
  items(rbind(items(), item))

  # -- notify
  if(shiny::isRunning())
    showNotification(paste(name, "Item created."), type = "message")

}
