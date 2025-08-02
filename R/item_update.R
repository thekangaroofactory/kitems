

#' Update item
#'
#' @param items a data.frame of the items
#' @param item a data.frame of the item(s) to be updated
#'
#' @export
#' @return the updated data.frame of the items
#'
#' @details
#' The item$id value will be used to replace the corresponding item(s) in the items data.frame
#' Item rows with id(s) not matching with id(s) in items will be dropped
#'
#' @examples
#' \dontrun{
#' item_update(items = myitems, item = myupdateditem)
#' }


item_update <- function(items, item){

  # -- drop rows not matching with existing id
  if(any(!item$id %in% items$id)){
    message("Removing not matching item(s), id(s) = " , item$id[!item$id %in% items$id])
    item <- item[item$id %in% items$id, ]}

  # -- check dim
  if(nrow(item) == 0)
    return(items)

  # -- replace item(s)
  items[items$id %in% item$id, ] <- item

  # -- return
  items

}
