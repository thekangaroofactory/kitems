

#' Item Update Workflow
#'
#' @param values a list or data.frame of values to create new item(s)
#' @param items a data.frame of the existing items
#' @param data.model a data.frame of the data model
#'
#' @returns the new data.frame of the items
#'
#' @examples
#' \dontrun{
#' item_update_workflow(items, data.model, values)
#' }

item_update_workflow <- function(values, items, data.model){

  # ////////////////////////////////////////////////////////////////////////////

  .Deprecated(
    new = "rows_update",
    package = "kitems")

  # ////////////////////////////////////////////////////////////////////////////

  # -- create item
  catl("- Create replacement item")
  item <- item_create(values, data.model)

  # -- update item & reactive
  catl("- Replace item")
  item_update(items, item)

}
