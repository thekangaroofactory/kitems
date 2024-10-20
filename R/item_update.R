

#' Update item
#'
#' @param items the reference! of the reactiveVal carrying the data.frame of the items
#' @param item the item to be updated
#'
#' @export
#'
#' @details
#' The item$id value will be used to replace the corresponding item in the items data.frame
#'
#' @examples
#' \dontrun{
#' item_update(items = myitems, item = myupdateditem)
#' }


item_update <- function(items, item){

  # -- check items
  stopifnot("reactiveVal" %in% class(items))

  # -- get value & update
  x <- items()
  x[x$id == item$id, ] <- item

  # -- store
  items(x)

}
