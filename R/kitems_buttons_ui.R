

# -- BTN: create item

#' Create item button
#'
#' @param id the server module id
#'
#' @return a rendered actionButton
#' @export
#'
#' @examples
#' create_BTN(id = "mydata")

create_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("create_btn"), inline = TRUE)

}


# -- BTN: update item

#' Update item button
#'
#' @param id the server module id
#'
#' @return a rendered actionButton
#' @export
#'
#' @examples
#' update_BTN(id = "mydata")

update_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("update_btn"), inline = TRUE)

}


# -- BTN: delete item

#' Delete item button
#'
#' @param id the server module id
#'
#' @return a rendered actionButton
#' @export
#'
#' @examples
#' delete_BTN(id = "mydata")

delete_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("delete_btn"), inline = TRUE)

}
