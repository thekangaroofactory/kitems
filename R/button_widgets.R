

#' Create Item Button
#'
#' @description
#' Button to fire the create item dialog.
#'
#' @param id the server module id.
#'
#' @return An HTML element that can be included in the UI.
#' @export
#'
#' @examples
#' \dontrun{
#' create_widget(id = "mydata")
#' }

create_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_create_btn"), inline = TRUE)

}


#' Update Item Button
#'
#' @description
#' Button to fire the update item dialog.
#'
#' @param id the server module id.
#'
#' @return An HTML element that can be included in the UI.
#' @export
#'
#' @examples
#' \dontrun{
#' update_widget(id = "mydata")
#' }

update_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_update_btn"), inline = TRUE)

}


#' Delete Item Button
#'
#' @description
#' Button to fire the delete item dialog.
#'
#' @param id the server module id.
#'
#' @return An HTML element that can be included in the UI.
#' @export
#'
#' @examples
#' \dontrun{
#' delete_widget(id = "mydata")
#' }

delete_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_delete_btn"), inline = TRUE)

}
