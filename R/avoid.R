

#' Avoid Attribute
#'
#' @description
#' Defines attribute(s) to avoid in the item form.
#'
#' @param data.model a data.frame of the data model
#' @param ... the name(s) of the attributes to avoid(quoted or unquoted)
#'
#' @details
#' When `...` is left empty, the function will act as a getter and return
#' a vector of the attribute name(s).
#'
#' @seealso [refresh()] [attribute_update()]
#'
#' @returns a data.frame of the updated data model or a character vector
#' @export
#'
#' @examples
#' avoid(data_model(c(foo = "character", bar = "logical")), bar)
#' avoid(data_model(c(foo = "character", bar = "logical")), foo, "bar")
#'
#' # getter
#' avoid(data_model(c(foo = "character", bar = "logical")))

avoid <- function(data.model, ...){

  # -- support unquoted names
  cols <- rlang::ensyms(...)

  # -- getter
  if(!length(cols))
    return(data.model[data.model$skip, 'name'])

  # -- setter
  attribute_update(data.model, name = cols, skip = TRUE)

}
