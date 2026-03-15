

#' Match Argument Type 1
#'
#' @description
#' This internal function is mostly used to check the arguments
#' of the `data_model()` function.
#'
#' @param x the argument to check
#' @param colClasses the colClasses argument passed to the builder function
#' @param mode a mode to pass to `is.vector()`
#' @param name the name of the argument
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' foo <- match_arg_t1(foo, colClasses, mode = "character")
#' }

match_arg_t1 <- function(x, colClasses, mode = "any", name = deparse(substitute(x))){

  if(!is.vector(x, mode))
    stop(paste(name, "must be a", if(mode != "any") mode, "vector"))

  if(is.null(names(x))){
    if(length(x) > 1 || length(names(colClasses)) > 1)
      stop(name, " must be named")
    else
      names(x) <- names(colClasses)}

  # -- return
  x

}


#' Match Argument Type 2
#'
#' @description
#' This internal function is mostly used to check the arguments
#' of the `data_model()` function.
#'
#' @param x the argument to check
#' @param default the default value for the argument
#' @param advice an optional verb to use for unsupported scenarios
#' @param name the name of the argument
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' foo <- match_arg_t2(foo, default = TRUE, advice = "skip")
#' }

match_arg_t2 <- function(x, default = FALSE, advice = NULL, name = deparse(substitute(x))){

  if(length(x) > 1)
    stop(paste(name, "must be a length-one logical", if(!is.null(advice)) paste("-- use", advice, "verb instead")))
  if(!is.logical(x))
    stop(paste(name, "must be a logical value"))
  if(is.na(x))
    x <- default

  # -- return
  x

}
