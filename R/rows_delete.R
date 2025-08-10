

#' Delete Item(s)
#'
#' @param items the data.frame of the items
#' @param id a vector of id(s) for the item to delete
#'
#' @return the new data.frame of the items
#' @export
#'
#' @examples
#' \dontrun{
#' rows_delete(items = myitems, id = 123456789)
#' }

rows_delete <- function(items, id){

  # -- drop unmatched id(s)
  if(any(!id %in% items$id))
    id <- id[id %in% items$id]

  # -- check
  if(length(id) < 1)
    stop("Can't delete item(s): id(s) not found")

  # -- drop item(s) & return
  catl("Deleting items: id =", id, level = 1)
  items[!items$id %in% id, ]

}
