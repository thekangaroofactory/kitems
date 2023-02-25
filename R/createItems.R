

#' Create item file
#'
#' @param path
#' @param file
#' @param colClasses
#'
#' @return
#' @export
#'
#' @examples


createItems <- function(path, file, colClasses){

  # get expected nb cols
  ncol <- length(colClasses)

  # create data frame with 0 rows and ncol columns
  items <- data.frame(matrix(ncol = ncol, nrow = 0))

  # set column names
  colnames(items) <- names(colClasses)

  # return
  items

}

