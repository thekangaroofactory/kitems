

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

  # -- check item structure #345
  ifelse(
    ncol(item) != ncol(items),
    stop("Can't add item to the items data.frame \n different column numbers"),

    # -- check column names
    ifelse(
      any(names(item) != names(items)),
      stop("Can't add item to the items data.frame \n different column names"),

      # -- check column classes
      ifelse(
        !all(lapply(items, class) %in% lapply(item, class)),
        stop("Can't add item to the items data.frame \n different column types"),

        # -- all checks passed (dummy return to avoid error)
        TRUE)))


  # -- rbind & return
  rbind(items, item)

}
