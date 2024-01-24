

#' Add item
#'
#' @param item an item data.frame to be added
#' @param items the items data.frame
#'
#' @return the updated items data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' item_add(items = myitems, item = mynewitem)
#' }

item_add <- function(items, item){

  # -- rbind
  items <- rbind(items, item)

}
