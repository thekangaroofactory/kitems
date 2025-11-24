

#' Update Item(s)
#'
#' @param items a data.frame of the items.
#' @param values a list of named values.
#' @param data.model a data.frame of the data.model.
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
#' rows_update(items, values, data.model)}

rows_update <- function(items, values, data.model){

  # ////////////////////////////////////////////////////////////////////////////
  # -- cleanup & prepare values

  # -- drop unmatched columns
  # before projection to avoid potential duplicated rows
  values <- values[names(values) %in% data.model$name]

  # -- secure against length 0 (NULL, numeric(0)...)
  # otherwise as.data.frame will fail
  if(any(lengths(values) == 0))
    values <- values[lengths(values) != 0]

  # -- make rectangular
  # elements must have length 1 or same as the id element
  values <- as.data.frame(values)

  # -- drop unmatched rows
  values <- values[values$id %in% items$id, ]


  # ////////////////////////////////////////////////////////////////////////////
  # -- check values & types

  values <- sapply(names(values),
                   function(x) attribute_value(key = x,
                                               value = values[[x]],
                                               data.model = data.model),
                   simplify = FALSE,
                   USE.NAMES = TRUE)


  # ////////////////////////////////////////////////////////////////////////////
  # -- replace item(s) values

  # -- columns to update (drop id)
  cols <- names(values)[!names(values) %in% "id"]

  # -- update rows / values
  items[items$id %in% values$id, cols] <- values[cols]

  # -- return
  items

}
