

#' Update Item(s)
#'
#' @param values a data.frame used to update the items.
#' @param items a data.frame of the items.
#'
#' @returns a data.frame of the items
#' @export
#'
#' @examples
#' \dontrun{
#' rows_update(values, items)}

rows_update <- function(values, items){

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
