

#' Turn Item Into Default Value(s)
#'
#' @param item the data.frame of the item to use as a reference.
#' @param data.model the data.frame of the data.model.
#'
#' @details
#' `item` and `data.model` must have same structure. That means the names
#' of the attributes in the data model are expected to match with the names
#' of the columns in item.
#'
#'
#' @returns a data.frame to pass to item_form() function.
#' @export
#'
#' @examples
#' \dontrun{
#' as_default(item, data.model)
#' }

as_default <- function(item, data.model){

  data.model |>
    dplyr::mutate(default = as.vector(item)) |>
    dplyr::filter(!skip) |>
    dplyr::select(c(name, type, default, values))

}
