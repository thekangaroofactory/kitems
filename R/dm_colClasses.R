

#' Data Model colClasses
#'
#' @description
#' Extract attribute classes from the data model.
#'
#' @param data.model a data.frame containing the data model.
#'
#' @return A named vector of the attribute types.
#' @export
#'
#' @examples
#' \dontrun{
#' dm_colClasses(data.model = mydatamodel)
#' }

dm_colClasses <- function(data.model = NULL){

  # -- Extract classes
  colClasses <- data.model$type
  names(colClasses) <- data.model$name

  # -- Return
  colClasses

}
