

#' Delete Attribute
#'
#' @description
#' Delete an attribute from the data.model & items
#'
#' @param data.model the data.model to update
#' @param items the items to update
#' @param name the name of the attribute to delete
#'
#' @return a named list(data.model, items)
#'
#' @details
#' The function returns a list so that both data.model & items
#' are treated in a single place. This ensures data integrity.
#'
#' @examples
#' \dontrun{
#' attribute_delete(dm, items, name = "comment")
#' }
#'

attribute_delete <- function(data.model, name, items){

  # -- checks
  # note: not mandatory since no error would occur, but we assume user
  # didn't want to do that
  if(!name %in% data.model$name)
    stop(name, "is not an attribute of the data model")

  # -- items
  # drop attribute from the items first (it won't bother is name is missing)
  catl("Drop attribute", name, "from items")
  items[name] <- NULL

  # -- data.model
  # drop attribute from the data.model (basically keep all others)
  catl("Drop", name, "from data model")
  x <- data.model[data.model$name != name, ]

  # -- check for empty data.model
  if(nrow(x) == 0){

    catl("Empty data model, cleaning data model & items")
    items <- NULL
    x <- NULL}

  # -- return
  list(data.model = x, items = items)

}
