

#' Update Item(s)
#'
#' @param items a data.frame of the items.
#' @param values a list of named values.
#'
#' @details
#' values is a named list. The names are used to check the corresponding values
#' vs the data.model (class, default values if the provided one is not valid).
#' The elements in the list must have either length one or same length as the id element.
#'
#' When an element has length one but the id has several values, all items corresponding
#' to these ids will be updated with same value. To do so, values will be turned into
#' a data.frame using as.data.frame ; for this reason, it's strongly advised to wrap
#' the call into tryCatch as this may fail.
#'
#' @returns a data.frame of the items
#' @export
#'
#' @examples
#' \dontrun{
#' rows_update(items, values)}

rows_update <- function(items, values){

  # ////////////////////////////////////////////////////////////////////////////
  # -- cleanup & prepare values

  # -- drop unmatched rows
  # replace [] by filter otherwise values = list(id = 123)
  # will brake df into a num vector (without name!)
  values <- values |> dplyr::filter(.data$id %in% items$id)


  # ////////////////////////////////////////////////////////////////////////////
  # -- replace item(s) values

  # -- columns to update (drop id)
  cols <- names(values)[!names(values) %in% "id"]

  # -- update rows / values
  items[items$id %in% values$id, cols] <- values[cols]

  # -- return
  items

}
