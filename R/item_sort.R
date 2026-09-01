

#' Sort Items
#'
#' @param items a data.frame of the items.
#' @param config the config list.
#' @param item the name (id) of the item group.
#'
#' @details
#' The sorting order is given by the sort entry in the config list.
#'
#' @seealso [organize()]
#'
#' @return a data.frame.
#' @export
#'
#' @examples
#' \dontrun{
#' items |> item_sort(config, item = "foo")
#' }
#'

item_sort <- function(items, config, item){

  # -- get & parse sort instruction
  raw <- config |> organized(item)
  catl("-- Sorting items by =", raw)
  seq <- rlang::parse_exprs(gsub(",", ";", raw))

  # -- do order items
  items |>
    dplyr::arrange(!!!seq)

}
