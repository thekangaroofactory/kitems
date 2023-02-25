


addColumn <- function(x, name, type, colClasses, fill = NA){

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
    if(type == "double") value <- as.double(fill)
    if(type == "integer") value <- as.integer(fill)
    if(type == "character") value <- as.character(fill)
    if(type == "date") value <- as.Date(fill)
    if(type == "POSIXct") value <- as.POSIXct(fill, origin = "1970-01-01")

    # add col
    x[name] <- value

  }

  # return
  x

}
