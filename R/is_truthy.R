

#' Truthy Value
#'
#' @param x an object to test.
#'
#' @description
#' Inspired by `Shiny::isTruthy()`, the purpose here is to determine if a value
#' is considered as valid to be an attribute value.
#' (or if it will need to be replaced by the attribute defaults).
#'
#' @returns A logical.
#' @export
#'
#' @examples
#' is_truthy(12)

is_truthy <- function (x) {

  if(is.null(x))
    return(FALSE)

  if(length(x) == 0)
    return(FALSE)

  if(!is.atomic(x))
    return(FALSE)

  if(all(is.na(x)))
    return(FALSE)

  if(is.character(x) && !nzchar((x)))
    return(FALSE)

  return(TRUE)

}
