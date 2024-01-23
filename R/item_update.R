

#' Update item
#'
#' @param items a data.frame of the items
#' @param item the items to be updated
#'
#' @return an updated data.frame of the items
#' @export
#'
#' @details
#' The item$id value will be used to replace the corresponding item in the items data.frame
#'
#' @examples
#' item_update(items = myitems, item = myupdateditem)


item_update <- function(items, item){

  # -- get target item id
  id <- item$id

  # -- update row
  items[items$id == id, ] <- item

  # -- return
  items

}
