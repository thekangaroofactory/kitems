

#' Check Integrity
#'
#' @description
#' Wrapper function to either check data.model or items integrity.
#'
#' @param x the object to check (data.model or items).
#' @param ... parameters to pass to the dedicated check integrity function.
#'
#' @details
#' `x` will be send to the first argument of the dedicated check integrity function.
#' At least one argument is expected in ...
#' See dm_integrity() or item_integrity() functions to know what is expected
#' as ... argument(s)
#'
#' @returns the output of the dedicated check integrity function
#' @export
#'
#' @examples
#' \dontrun{
#' data_model |> check(items = foo, fix = FALSE)
#' items |> check(data.model = foo, fix = TRUE)
#' }

check <- function(x, ...){

    arg <- list(...)

    if(!length(arg))
      stop("At least one argument should be supplied to ...")

    if("data.model" %in% names(arg))
      item_integrity(items = x, ...)

    if("items" %in% names(arg))
      dm_integrity(data.model = x, ...)

}
