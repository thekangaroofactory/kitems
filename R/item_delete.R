

#' Title
#'
#' @param items
#' @param id
#'
#' @return
#' @export
#'
#' @examples


item_delete <- function(items, id){

  # -- drop item
  items[items$id != id, ]

}
