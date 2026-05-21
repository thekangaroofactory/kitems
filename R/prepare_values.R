

#' Prepare Values
#'
#' @description
#' Turn trigger input values into tabular data
#'
#' @param values a list of values.
#' @param data.model the data.frame of the data model.
#' @param update a logical if values are used in the update workflow (default FALSE).
#'
#' @details
#' values is a named list. The names are used to check the corresponding values
#' vs the data.model (class, default values if the provided ones are not valid).
#' The elements in the list must have either length one or same length as the id element.
#'
#' When an element has length one but the id has several values, all items corresponding
#' to these ids will be updated with same value. To do so, values will be turned into
#' a data.frame using as.data.frame ; for this reason, it's strongly advised to wrap
#' the call into tryCatch as this may fail.
#'
#' @returns a data.frame of values
#' @export
#'
#' @examples
#' \dontrun{
#' prepare_values(values, data.model)
#' }

prepare_values <- function(values, data.model, update = FALSE){

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


  # ////////////////////////////////////////////////////////////////////////////
  # -- Specific to create

  # -- secure against missing columns
  if(!update)
    if(any(!data.model$name %in% names(values))){
      catl("- Adding missing columns", level = 2)
      values[data.model$name[!data.model$name %in% names(values)]] <- NA
      values <- values[data.model$name]}


  # ////////////////////////////////////////////////////////////////////////////
  # -- Specific to update

  # -- check skipped attributes to refresh
  # add names to values so they will be computed again
  if(update){
    att_refresh <- data.model |> dplyr::filter(.data$skip, .data$refresh) |> dplyr::pull(.data$name)
    att_refresh <- att_refresh[!att_refresh %in% names(values)]
    if(!identical(att_refresh, character(0)))
      values <- c(values, as.list(stats::setNames(NA, att_refresh)))}

  # -- return
  values

}
