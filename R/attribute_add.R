

#' Title
#'
#' @param x
#' @param name
#' @param type
#' @param fill
#' @param coerce
#'
#' @return
#' @export
#'
#' @examples

attribute_add <- function(x, name, type, fill = NA, coerce){

  # check dim
  if(dim(x)[1] == 0){

    # get col names and add
    cols <- colnames(x)
    cols[length(cols) + 1] <- name

    # build new empty df and set names
    x <- data.frame(matrix(ncol = length(cols), nrow = 0))
    colnames(x) <- cols

  } else {

    # coerce to type (NA is logical by default)
    # if(type == "double") value <- as.double(fill)
    # if(type == "integer") value <- as.integer(fill)
    # if(type == "character") value <- as.character(fill)
    # if(type == "Date") value <- as.Date(fill)
    # if(type == "POSIXct") value <- as.POSIXct(fill, origin = "1970-01-01")

    # -- coerce value
    cat("Coerce value to given class \n")
    value <- eval(call(coerce[[type]], fill))
    cat("Output: \n")
    str(value)

    # add col
    x[name] <- value

  }

  # return
  x

}
