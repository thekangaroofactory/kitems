

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

  # -- check id
  if(!all(id %in% items$id))
    stop("Can't delete item - id does not exist in items list")

  # -- drop item & return
  items[!items$id %in% id, ]

}
