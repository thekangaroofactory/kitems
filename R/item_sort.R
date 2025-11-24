

#' Sort Items
#'
#' @param items a data.frame of the items.
#' @param data.model a data.frame of the data model.
#'
#' @return A data.frame of the items, sorted based on the data model.
#' @export
#'
#' @examples
#' \dontrun{
#' item_sort(items, data.model)
#' }
#'

item_sort <- function(items, data.model){

  # -- get sort info
  # ordered & ignore sort.rank = NA
  sorting <- data.model[order(data.model$sort.rank, na.last = NA), c("name", "sort.rank", "sort.desc")]
  catl("[item_sort] -- Sorting items by =", paste(sorting$name, ifelse(sorting$sort.desc, "desc.", ""), collapse = ", "))

  # -- order by column(s)
  items[do.call(order, c(items[sorting$name], list(decreasing = sorting$sort.desc))), ]

}
