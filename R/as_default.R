

#' Turn Item Into Default Value(s)
#'
#' @param item the data.frame of the item to use as a reference.
#' @param data.model the data.frame of the data.model (see details).
#'
#' @details
#' This function does not accept the data.model element of the config list as an input.
#' It should be turned into a data.frame first, using [yaml_to_dm()].
#'
#' `data.model` should contain the following columns:
#' "name", "type", "default", "values".
#'
#' `item` and `data.model` must have same structure. That means the names
#' of the attributes in the data model are expected to match with the names
#' of the columns in item.
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

  # -- turn item value(s) into default(s)
  data.model |>
    dplyr::mutate(default = as.character(item)) |>
    dplyr::select(dplyr::any_of(c("name", "type", "default", "values")))

}
