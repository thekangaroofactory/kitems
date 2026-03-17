

#' Ask Attribute(s)
#'
#' @description
#' Set attribute(s) to include in the item form.
#'
#' @param data.model a data.frame of the data model
#' @param ... the name(s) of the attributes to include / reset (quoted or unquoted)
#'
#' @details
#' When `...` is left empty, the function will act as a getter and return
#' a vector of the attribute name(s).
#'
#' @returns a data.frame of the updated data model or a character vector
#' @export
#'
#' @seealso [avoid()] [attribute_update()]
#'
#' @examples
#' ask(data_model(c(foo = "character"), skip = TRUE), foo)
#' ask(data_model(c(foo = "character"), skip = TRUE, refresh = TRUE), "foo")
#' ask(data_model(c(foo = "character", bar = "logical"), skip = TRUE), "foo", bar)
#'
#' # getter
#' ask(data_model(c(foo = "character")))

ask <- function(data.model, ...){

  # -- support unquoted names
  cols <- rlang::ensyms(...)

  # -- getter
  if(!length(cols))
    return(data.model[!data.model$skip, 'name'])

  # -- setter
  attribute_update(data.model, name = cols, skip = FALSE)

}
