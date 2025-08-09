

#' Item Create Workflow
#'
#' @param items a data.frame of the existing items
#' @param data.model a data.frame of the data model
#' @param values a list or data.frame of values to create new item(s)
#'
#' @returns the new data.frame of the items
#'
#' @examples
#' \dontrun{
#' item_create_workflow(items, data.model, values)
#' }

item_create_workflow <- function(items, data.model, values){

  # ////////////////////////////////////////////////////////////////////////////

  .Deprecated(
    new = "rows_insert",
    package = "kitems")

  # ////////////////////////////////////////////////////////////////////////////

  # -- create item
  catl("- create item(s)")
  item <- item_create(values, data.model)

  # -- add to items & store
  catl("- add to existing items")
  item_add(items, item)

}
