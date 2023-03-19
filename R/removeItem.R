


removeItem <- function(id = NULL, items = NULL, path = NULL, file = NULL){

  # log
  cat("Removing list item \n")

  # drop item
  items <- items[!items$id == id, ]

  # call save (ignored if path OR file = NULL)
  if((is.null(path) || is.null(file))){

    cat("[WARNING] Path or file is not provided. No save will be done! \n")

  } else {

    saveItems(path, file, items)

  }

  # return
  items

}
