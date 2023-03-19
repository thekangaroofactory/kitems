

#' Load Items from CSV
#'
#' @param path the path where to read the file.
#' @param file the name of the file which the data are to be read from.
#' @param item a list ...
#'
#' @return a data.frame of the read items, with column names and classes...
#' @export
#'
#' @examples loadItems(path = "target/path", file = "target_file.csv", item = xxxxx)


loadItems <- function(path = NULL, file = NULL, item = NULL){

  # build target file
  target_url <- file.path(path, file)

  # log
  cat("Loading items from file ", target_url, "\n")

  # get col names and classes
  col_names <- names(item)
  col_classes <- item

  # read csv file
  raw_items <- read.csv(file = target_url,
                        header = TRUE,
                        sep = ",",
                        quote = "\"",
                        dec = ".",
                        fill = TRUE,
                        col.names = col_names,
                        colClasses = col_classes,
                        encoding = "UTF-8")



}
