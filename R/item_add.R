

#' Add item
#'
#' @param item an item data.frame to be added
#' @param items the reference! of the reactive value carrying the items
#'
#' @export
#'
#' @examples
#' \dontrun{
#' item_add(items = myitems, item = mynewitem)
#' }

item_add <- function(items, item){

  # -- check items
  stopifnot("reactiveVal" %in% class(items))

  # -- rbind & store
  items(rbind(items(), item))

}
