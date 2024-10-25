

#' Update item
#'
#' @param items the data.frame of the items
#' @param item the item to be updated
#'
#' @export
#' @return the new data.frame of the items
#'
#' @details
#' The item$id value will be used to replace the corresponding item in the items data.frame
#'
#' @examples
#' \dontrun{
#' item_update(items = myitems, item = myupdateditem)
#' }


item_update <- function(items, item){

  # -- get value & update
  items[items$id == item$id, ] <- item

  # -- return
  items

}
