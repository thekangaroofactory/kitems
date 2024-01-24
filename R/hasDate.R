

#' Test date attribute
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a logical, TRUE if data model has an attribute 'date' (exact match)
#'
#' @examples
#' \dontrun{
#' hasDate(data.model = mydatamodel)
#' }


hasDate <- function(data.model){

  # -- basic: test if attribute date exists
  value <- "date" %in% data.model$name

}
