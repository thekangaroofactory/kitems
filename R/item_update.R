

#' Title
#'
#' @param items
#' @param item
#'
#' @return
#' @export
#'
#' @examples


item_update <- function(items, item){

  # -- get target item id
  id <- item$id

  # -- update row
  items[items$id == id, ] <- item

  # -- return
  items

}
