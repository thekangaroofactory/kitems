

# -- BTN: create item

#' Title
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples

create_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("create_btn"), inline = TRUE)

}


# -- BTN: update item

#' Title
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples

update_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("update_btn"), inline = TRUE)

}


# -- BTN: delete item

#' Title
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples

delete_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("delete_btn"), inline = TRUE)

}
