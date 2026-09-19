

#' Call Conversion Functions
#'
#' @description
#' Helper function to call the class conversion functions with arguments
#'
#' @param x the object to be converted
#' @param class the target class
#' @param class.arg a character string with the arguments (see details)
#'
#' @details
#' `class.arg` must be like "list(arg1 = 12, arg2 = 'foo')"
#'
#' @keywords internal
#' @returns the converted object
#'
#' @examples
#' \dontrun{
#' convert("2025-09-10T13:16:55Z", "POSIXct", "list(format = '%Y-%m-%dT%H:%M:%S')")
#' }

convert <- function(x, class, class.arg = NULL){

  # -- check argument
  if(is.null(class.arg) || is.na(class.arg))
    eval(call(CLASS_FUNCTIONS[[class]], x))
  else
    eval(do.call(CLASS_FUNCTIONS[[class]], c(list(x), eval(parse(text = class.arg)))))

}
