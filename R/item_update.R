

#' Update item
#'
#' @param items the reference! of the reactiveVal carrying the data.frame of the items
#' @param item the item to be updated
#' @param name a character string used inside the notification (typically the name of the items)
#'
#' @export
#'
#' @details
#' The item$id value will be used to replace the corresponding item in the items data.frame
#'
#' @examples
#' \dontrun{
#' item_update(items = myitems, item = myupdateditem, name = "myitem")
#' }


item_update <- function(items, item, name = NULL){

  # -- check items
  stopifnot("reactiveVal" %in% class(items))

  # -- get value & update
  x <- items()
  x[x$id == item$id, ] <- item

  # -- store
  items(x)

  # -- notify
  if(shiny::isRunning())
    showNotification(paste(name, "Item updated."), type = "message")

}
