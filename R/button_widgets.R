

#' Item Buttons
#'
#' @description
#' Action button(s) to fire the item dialog.
#'
#' @param id the server module id.
#'
#' @details
#' `id` is the namespace of the module server instance holding
#' the target item.
#'
#' - create_widget() to fire create dialog
#' - update_widget() to fire update dialog
#' - delete_widget() to fire delete dialog
#' - actions_widget() is a wrapper that returns all there buttons.
#'
#' @return An HTML tag.
#' @export
#'
#' @examples
#' \dontrun{
#' # assuming the module server has been launched with id = "mydata"
#' create_widget(id = "mydata")
#' }

create_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_create_btn"), inline = TRUE)

}


#' @rdname create_widget
#' @export

update_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_update_btn"), inline = TRUE)

}


#' @rdname create_widget
#' @export

delete_widget <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("item_delete_btn"), inline = TRUE)

}


#' @rdname create_widget
#' @export

actions_widget <- function(id){

  tagList(
    create_widget(id),
    update_widget(id),
    delete_widget(id))

}
