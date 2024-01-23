

#' Delete item
#'
#' @param items a data.frame of the items
#' @param id the id of the item to delete
#'
#' @return an updated data.frame of the items
#' @export
#'
#' @examples
#' item_delete(items = myitems, id = 123456789)


item_delete <- function(items, id){

  # -- drop item
  items[!items$id %in% id, ]

}
