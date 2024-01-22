

#' Title
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples

items_view_DT <- function(id){

  # -- namespace
  ns <- NS(id)

  # -- the table
  DT::DTOutput(ns("default_view"))

}


#' Title
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples

items_filtered_view_DT <- function(id){

  # -- namespace
  ns <- NS(id)

  # -- the table
  DT::DTOutput(ns("filtered_view"))

}
