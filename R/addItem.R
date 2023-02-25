

#' Add Item to List
#'
#' @param x
#' @param items
#' @param path
#' @param file
#' @param sort column name or index
#'
#' @return
#' @export addItem
#'
#' @examples

addItem <- function(x, items = NULL, path = NULL, file = NULL, sort = NULL){

  # log
  cat("Adding item to item list \n")

  # check input class
  if(!is.data.frame(x)){

    # make as data.frame
    x <- as.data.frame(x)

  }

  # merge to list
  items <- rbind(items, x)

  # sort list (ignored if sort = NULL)
  if(!is.null(sort)){

    cat("Sort item list by", sort, "\n")
    items <- items[order(items[, sort]), ]

  }

  # call save (ignored if path OR file = NULL)
  if((is.null(path) || is.null(file))){

    cat("[WARNING] Path or file is not provided. No save will be done! \n")

  } else {

    saveItems(path, file, items)

  }

  # return
  items

}
