

#' Display Attribute(s)
#'
#' @description
#' Basically the opposite of the `hide()` function
#'
#' @param data.model a data.frame of the data model
#' @param ... the name(s) of the attributes to set as displayed (quoted or unquoted)
#'
#' @details
#' When `...` is left empty, the function will act as a getter and return
#' a vector of the displayed attribute's names.
#'
#' @returns a data.frame of the updated data model or a character vector
#' @export
#'
#' @seealso [hide()] [attribute_update()]
#'
#' @examples
#' display(data_model(c(foo = "character")), id)
#' display(data_model(c(foo = "character")), "id")
#' display(data_model(c(foo = "character", bar = "logical")), "foo", bar)
#'
#' # getter
#' display(data_model(c(foo = "character")))

display <- function(data.model, ...){

  # -- support unquoted names
  cols <- rlang::ensyms(...)

  # -- getter
  if(!length(cols))
    return(data.model[data.model$display, 'name'])

  # -- setter
  attribute_update(data.model, name = cols, display = TRUE)

}
