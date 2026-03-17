

#' Hide Attribute(s)
#'
#' @description
#' Hide attribute(s) from the data model or get the hidden ones.
#'
#' @param data.model a data.frame of the data model
#' @param ... the name(s) of the attributes to hide (quoted or unquoted)
#'
#' @details
#' When `...` is left empty, the function will act as a getter and return
#' a vector of the hidden attribute's names.
#'
#' @returns a data.frame of the updated data model or a character vector
#' @export
#'
#' @examples
#' hide(data_model(c(foo = "character")), foo)
#' hide(data_model(c(foo = "character")), "foo")
#' hide(data_model(c(foo = "character", bar = "logical")), "foo", bar)
#'
#' # getter
#' hide(data_model(c(foo = "character")))

hide <- function(data.model, ...){

  # -- support unquoted names
  cols <- rlang::ensyms(...)

  # -- getter
  if(!length(cols))
    return(data.model[!data.model$display, 'name'])

  # -- secure
  # we need at least one attribute in the data.model
  if(all(!cols %in% data.model$name)){
    warning("Attribute not found in the data.model.")
    return(data.model)}

  # -- setter
  data.model[data.model$name %in% cols, ]$display <- FALSE
  data.model

}
