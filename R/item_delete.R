

#' Delete item
#'
#' @param items the reference! of the reactive value carrying the items
#' @param id the id of the item to delete
#' @param name a character string used inside the notification (typically the name of the items)
#'
#' @return an updated data.frame of the items
#' @export
#'
#' @examples
#' \dontrun{
#' item_delete(items = myitems, id = 123456789, name = "myitems")
#' }


item_delete <- function(items, id, name = NULL){

  # -- check items
  stopifnot("reactiveVal" %in% class(items))

  # -- trace
  MODULE <- paste0("[", ifelse(is.null(name), "kitems", name), "]")
  cat(MODULE, "Delete item(s) \n")
  cat("-- Item(s) to be deleted =", as.character(id), "\n")

  # -- drop item & store
  x <- items()[!items()$id %in% id, ]
  items(x)

  # -- notify
  if(shiny::isRunning())
    showNotification(paste(MODULE, "Item(s) deleted."), type = "message")

}
