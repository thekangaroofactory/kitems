

#' Load Items
#'
#' @param connector a list parameters that will passed to iker::load_data() call.
#' @param col.classes a named vector containing the expected column types.
#'
#' @return The data.frame of the items.
#' @export
#'
#' @examples
#' \dontrun{
#' # -- File connector:
#' item_load(col.classes = c(id = "numeric", date = "Date", comment = "character"),
#' connector = list(type = "file", path = "path/to/my/data", filename = "mydata.csv")
#' }

item_load <- function(connector, col.classes){

  # -- read data
  items <- iker::load_data(path = connector$path,
                           file = connector$file,
                           delim = ",",
                           col_types = col.classes,
                           data.frame = TRUE)

  # -- check output size
  # will trigger showing the create button
  if(all(dim(items) == c(0,0)))
    items <- NULL

  # -- return
  items

}
