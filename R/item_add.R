

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

  # -- check id uniqueness #330
  if(item$id %in% items$id)
    stop("Can't add item to the items data.frame \n id is not unique")

  # -- check item structure #345
  ifelse(
    ncol(item) != ncol(items()),
    stop("Can't add item to the items data.frame \n different column numbers"),

    # -- check column names
    ifelse(
      names(item) != names(items()),
      stop("Can't add item to the items data.frame \n different column names"),

      # -- check column classes
      if(class(item) != class(items()))
        stop("Can't add item to the items data.frame \n different column types")))


  # -- rbind & store
  items(rbind(items(), item))

}
