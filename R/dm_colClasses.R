

#' Data Model colClasses
#'
#' @description
#' Extract attribute classes from the data model.
#'
#' @param data.model a data.frame of the data model.
#'
#' @return A named vector of the attribute types.
#' @export
#'
#' @examples
#' dm_colClasses(data.model = data_model(colClasses = c(name = "character", total = "numeric")))

dm_colClasses <- function(data.model){

  stats::setNames(data.model$type, data.model$name)

}
