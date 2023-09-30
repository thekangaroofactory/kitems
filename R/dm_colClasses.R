

#' Extract colClasses from data model
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a named vector
#' @export
#'
#' @examples


dm_colClasses <- function(data.model = NULL){

  # -- Extract classes
  colClasses <- data.model$type
  names(colClasses) <- data.model$name

  # -- Return
  colClasses

}
