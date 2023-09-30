

#' this trick to solve the use of :: for package functions
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples


# ***********************************************************
# >> should be exported to ktools package for reuse


getfun <- function(x) {
  if(length(grep("::", x)) > 0) {
    parts <- strsplit(x, "::")[[1]]
    getExportedValue(parts[1], parts[2])
  } else {
    x
  }
}

# ***********************************************************
