

#' Load data
#'
#' @param col.classes a vector containing the expected column types
#' @param file an optional file name (including .csv extension)
#' @param path an optional path to the file
#'
#' @return the data (items)
#' @export
#'
#' @details
#' File connector: if file is not NULL, then data are loaded from the given .csv
#'
#' @examples
#' \dontrun{
#' # -- File connector:
#' item_load(col.classes = c(id = "numeric", date = "Date", comment = "character"),
#' file = "mydata.csv", path = "path/to/my/data")
#' }


item_load <- function(col.classes, file = NULL, path = NULL){

  # -- Init
  items <- NULL

  # ----------------------------------------------------------------------------
  # Connector: file (.csv)
  # ----------------------------------------------------------------------------
  if(!is.null(file))

    # -- read data
    items <- as.data.frame(iker::read_data(path = path,
                                           file = file,
                                           delim = ",",
                                           col_types = col.classes))


  # ----------------------------------------------------------------------------

  # -- check output size (will trigger showing the create data btn)
  if(all(dim(items) == c(0,0)))
    items <- NULL

  # -- return
  items

}
