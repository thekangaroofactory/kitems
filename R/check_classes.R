

#' Title
#'
#' @param items
#' @param colClasses
#'
#' @return
#' @export
#'
#' @examples


check_classes <- function(items, colClasses){

  # -- get items data.frame column names
  column_names <- colnames(items)

  # -- check colClasses (all df cols must be declared)
  # note: if not initialized, colClasses is NA! (not NULL)
  if(!all(is.na(colClasses)))
    if(!all(column_names %in% names(colClasses))){

      cat("- fixing colClasses! \n")

      # -- get missing names & classes
      missing_cols <- column_names[!column_names %in% names(colClasses)]
      missing_classes <- sapply(items[missing_cols], class)

      # -- add missing classes
      colClasses[missing_cols] <- missing_classes}

  # -- return
  colClasses

}
