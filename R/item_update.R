

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

  # -- delete then add..
  items <- item_delete(items, id)
  items <- item_add(items, item)

}
