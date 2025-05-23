

#' Add attribute to existing items
#'
#' @param items a data.frame of the items
#' @param name a character string of the attribute name
#' @param type a character string of the attribute type
#' @param fill the value (default = NA) to be used to fill the existing rows (see details)
#'
#' @return the updated items data.frame
#' @export
#'
#' @details
#' fill will be coerced to the class name provided in type
#' If a vector is given as input for fill, it will be used: items[name] <- value
#' Make sure the vector length is same as the number of rows, otherwise an error will be raised by R
#'
#' @examples
#' \dontrun{
#' item_migrate(items = myitems, name = "comment", type = "character", fill = "none")
#' }

item_migrate <- function(items, name, type, fill = NA){

  # -- Check dim
  if(nrow(items) == 0){

    # -- Get col names and add
    cols <- colnames(items)
    cols[length(cols) + 1] <- name

    # -- Build new empty df and set names
    items <- data.frame(matrix(ncol = length(cols), nrow = 0))
    colnames(items) <- cols

  } else {

    # -- check fill length
    if(length(fill) != nrow(items) & length(fill) != 1){
      catl("-- Warning! fill length does not match with nrow(items), setting fill = NA", debug = 1)
      fill <- NA}

    # -- check & coerce fill class
    if(! type %in% class(fill)){

      fill <- eval(call(CLASS_FUNCTIONS[[type]], fill))
      catl("-- Warning! fill type does not match with expected one, coerce value(s):", class(fill), fill, debug = 1)}

    # -- Add col
    items[name] <- fill

  }

  # -- Return
  items

}
