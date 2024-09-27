

#' Data model name
#'
#' @param id the id of the module server instance
#'
#' @return the name of the corresponding reactive value
#' @export
#'
#' @examples
#' dm_name(id = "mydata")

dm_name <- function(id){paste0(id, "_data_model")}


#' Items name
#'
#' @param id the id of the module server instance
#'
#' @return the name of the corresponding reactive value
#' @export
#'
#' @examples
#' items_name(id = "mydata")

items_name <- function(id){paste0(id, "_items")}


#' Trigger update name
#'
#' @param id the id of the module server instance
#'
#' @return the name of the corresponding reactive value
#' @export
#'
#' @examples
#' trigger_update_name(id = "mydata")

trigger_update_name <- function(id){paste0(id, "_trigger_update")}


#' Trigger create name
#'
#' @param id the id of the module server instance
#'
#' @return the name of the corresponding reactive value
#' @export
#'
#' @examples
#' trigger_create_name(id = "mydata")

trigger_create_name <- function(id){paste0(id, "_trigger_create")}
