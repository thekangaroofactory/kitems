

#' Refresh Skipped Attribute
#'
#' @description
#' Defines skipped attribute(s) that need a refresh during item update.
#'
#' @param data.model a data.frame of the data model
#' @param ... the name(s) of the attributes to refresh (quoted or unquoted)
#'
#' @details
#' When `...` is left empty, the function will act as a getter and return
#' a vector of the attribute name(s).
#'
#' @seealso [avoid()] [attribute_update()]
#'
#' @returns a data.frame of the updated data model or a character vector
#' @export
#'
#' @examples
#' refresh(avoid(data_model(c(foo = "character", bar = "logical")), bar), bar)
#'
#' # attributes not skipped will be ignored
#' refresh(data_model(c(foo = "character", bar = "logical")), bar)
#'
#' # getter
#' refresh(data_model(c(foo = "character", bar = "logical")))

refresh <- function(data.model, ...){

  # -- support unquoted names
  cols <- rlang::ensyms(...)

  # -- getter
  if(!length(cols))
    return(data.model[data.model$refresh, 'name'])

  # -- check
  # drop attributes that are not skipped
  if(!all(data.model[data.model$name %in% cols, 'skip'])){
    warning("Some attribute(s) are not skipped (they will be ignored).")
    cols <- data.model[data.model$name %in% cols & data.model$skip, 'name']}
  if(!length(cols))
    return(data.model)

  # -- setter
  attribute_update(data.model, name = cols, skip = TRUE, refresh = TRUE)

}
