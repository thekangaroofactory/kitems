

#' Add attribute to existing items
#'
#' @param items a data.frame of the items
#' @param name a character string of the attribute name
#' @param type a character string of the attribute type
#' @param fill the value (default = NA) to be used to fill the existing rows
#'
#' @return the updated items data.frame
#' @export
#'
#' @details
#' fill will be coerced to the class name provided in type
#'
#' @examples
#' \dontrun{
#' item_add_attribute(items = myitems, name = "comment", type = "character", fill = "none")
#' }

item_add_attribute <- function(items, name, type, fill = NA){

  # -- Check dim
  if(dim(items)[1] == 0){

    # -- Get col names and add
    cols <- colnames(items)
    cols[length(cols) + 1] <- name

    # -- Build new empty df and set names
    items <- data.frame(matrix(ncol = length(cols), nrow = 0))
    colnames(items) <- cols

  } else {

    # -- coerce value
    cat("Coerce value to given class \n")
    value <- eval(call(CLASS_FUNCTIONS[[type]], fill))
    cat("Output:", class(value), value, "\n")

    # -- Add col
    items[name] <- value

  }

  # -- Return
  items

}
