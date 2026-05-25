

#' Item Migration
#'
#' @description
#' Add attribute to existing items.
#'
#' @param items a data.frame of the items.
#' @param name a character string of the attribute name.
#' @param type a character string of the attribute type.
#' @param fill the value (default = `NA`) to be used to fill the existing rows (see details).
#'
#' @return The updated items data.frame.
#' @export
#'
#' @details
#' `fill` will be coerced to the class name provided in `type`.
#' If a vector is given as input for `fill`, it will be used to feed the created column.
#' Make sure the vector length is same as the number of rows, otherwise an error will be raised by R.
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
      warnings("fill should either be same length as items or 1, setting fill = NA")
      fill <- NA}

    # -- check & coerce fill class
    if(! type %in% class(fill)){

      fill <- convert(fill, type)
      catl("coerce value(s) to expected type:", class(fill), debug = 1)}

    # -- Add col
    items[name] <- fill

  }

  # -- Return
  items

}
