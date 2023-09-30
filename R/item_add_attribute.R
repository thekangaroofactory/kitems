

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

item_add_attribute <- function(x, name, type, fill = NA, coerce){

  # -- Check dim
  if(dim(x)[1] == 0){

    # -- Get col names and add
    cols <- colnames(x)
    cols[length(cols) + 1] <- name

    # -- Build new empty df and set names
    x <- data.frame(matrix(ncol = length(cols), nrow = 0))
    colnames(x) <- cols

  } else {

    # -- coerce value
    cat("Coerce value to given class \n")
    value <- eval(call(coerce[[type]], fill))
    cat("Output: \n")
    str(value)

    # -- Add col
    x[name] <- value

  }

  # -- Return
  x

}
