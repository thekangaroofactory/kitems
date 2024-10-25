

#' Delete item
#'
#' @param items the data.frame of the items
#' @param id the id of the item to delete
#'
#' @return the new data.frame of the items
#' @export
#'
#' @examples
#' \dontrun{
#' item_delete(items = myitems, id = 123456789)
#' }


item_delete <- function(items, id){

  # -- drop item & store
  items[!items$id %in% id, ]

}
