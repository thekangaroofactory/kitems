

#' Sort Attributes
#'
#' @description
#' Get or set sorting order of the data.model
#'
#' @param data.model a data.frame of the data model
#' @param ... the name(s) of the attributes to use for sorting (quoted or unquoted).
#' Use desc() for descending order (see examples).
#'
#' @details
#' When `...` is left empty, the function will act as a getter and return
#' a data.frame of the attributes used to sort the items.
#'
#' Ranking depends on the position of the attribute.
#'
#' @returns a data.frame of the updated data model or of the sorting parameters
#' @export
#'
#' @examples
#'
#' dm <- data_model(c(foo = "character", bar = "logical", zoo = "numeric"))
#'
#' # Sort by attribute foo (ascending order)
#' organize(dm, foo)
#'
#' # Sort by attribute foo (descending order)
#' organize(dm, desc(foo))
#'
#' # Sort by attribute foo, then bar (descending order)
#' organize(dm, foo, desc(bar))

organize <- function(data.model, ...){

  # -- get quosure
  # returns a list of quosures
  expr <- rlang::enquos(...)

  # -- check for empty ...
  if(!length(expr))
    return(data.model[!is.na(data.model$sort.rank), c("name", "sort.rank", "sort.desc")])

  # -- get to know if desc(foo) is used
  # returns a logical vector
  idx <- sapply(expr, function(x) rlang::quo_is_call(x, name = "desc"))

  # -- drop desc call
  # returns a character vector
  cols <- sapply(expr, function(x) if(rlang::quo_is_call(x, name = "desc")) as.character(rlang::call_args(rlang::quo_get_expr(x))) else as.character(rlang::quo_get_expr(x)))

  # -- prepare arguments
  sort.rank <- stats::setNames(1:length(cols), cols)
  sort.desc <- stats::setNames(idx, cols[idx])

  # -- do attribute update
  attribute_update(data.model, name = cols, sort.rank = sort.rank, sort.desc = sort.desc)

}
