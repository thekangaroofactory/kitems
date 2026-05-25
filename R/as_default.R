

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

  # -- ensure datetime is kept
  # otherwise conversion may loose time or tz
  if("POSIXct" %in% data.model$type)
    item[data.model$name[data.model$type == "POSIXct"]] <- format(item[data.model$name[data.model$type == "POSIXct"]], "%FT%H:%M:%S%z")

  # -- turn into default(s)
  data.model |>
    dplyr::mutate(default = as.character(item)) |>
    dplyr::filter(!skip) |>
    dplyr::select(c(name, type, default, values))

}
