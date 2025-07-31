

#' Add item
#'
#' @param items the data.frame of the items
#' @param item an item data.frame to be added
#'
#' @export
#' @return the new data.frame of the items
#'
#' @examples
#' \dontrun{
#' item_add(items = myitems, item = mynewitem)
#' }

item_add <- function(items, item){

  # -- check id uniqueness #330
  if(item$id %in% items$id)
    stop("Can't add item to the items data.frame \n id is not unique")

  # -- rbind & return
  rbind(items, item)

}
