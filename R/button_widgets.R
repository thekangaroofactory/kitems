

#' Create Item Button
#'
#' @param id the server module id
#'
#' @return a rendered actionButton
#' @export
#'
#' @examples
#' create_widget(id = "mydata")

create_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_create_btn"), inline = TRUE)

}


#' Update Item Button
#'
#' @param id the server module id
#'
#' @return a rendered actionButton
#' @export
#'
#' @examples
#' update_widget(id = "mydata")

update_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_update_btn"), inline = TRUE)

}


#' Delete Item Button
#'
#' @param id the server module id
#'
#' @return a rendered actionButton
#' @export
#'
#' @examples
#' delete_widget(id = "mydata")

delete_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_delete"), inline = TRUE)

}
