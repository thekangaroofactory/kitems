

#' Prepare Values
#'
#' @description
#' Turn trigger input values into tabular data
#'
#' @param values a list of values.
#' @param config the config list.
#' @param update a logical if values are used in the update workflow (default FALSE).
#' @param item optional (see details), the name (id) of the item group.
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
#' When `item` is set in the parent frame, then the attribute can be skipped
#' in the function call.
#'
#' @seealso [parent.frame()]
#'
#' @returns a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' prepare_values(values, config, item = "foo")
#' }

prepare_values <- function(values, config, update = FALSE, item = get_context()){

  # get attribute names
  att_names <- config_attributes(config, item)


  # ////////////////////////////////////////////////////////////////////////////
  # -- cleanup & prepare values

  # -- drop unmatched columns
  # before projection to avoid potential duplicated rows
  values <- values[names(values) %in% att_names]

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
    if(any(att_missing <- !att_names %in% names(values))){
      catl("- Adding missing columns", level = 2)
      values[att_names[att_missing]] <- NA
      values <- values[att_names]}


  # ////////////////////////////////////////////////////////////////////////////
  # -- Specific to update

  # -- check skipped attributes to refresh
  # add names to values so they will be computed again
  if(update){
    att_refresh <- config_item_behavior(config, item, behavior = "refresh")
    att_refresh <- att_refresh[!att_refresh %in% names(values)]
    if(!identical(att_refresh, character(0)))
      values <- c(values, as.list(stats::setNames(NA, att_refresh)))}

  # -- return
  values

}
