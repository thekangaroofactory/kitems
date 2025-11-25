

#' Data Model Name
#'
#' @description
#' Helper function to compute the data model name.
#'
#'
#' @param id the id of the module server instance.
#'
#' @return The name of the corresponding data model.
#' @export
#'
#' @examples
#' dm_name(id = "mydata")

dm_name <- function(id){paste0(id, "_data_model")}


#' Items Name
#'
#' @description
#' Helper function to compute the items name.
#'
#' @param id the id of the module server instance
#'
#' @return The name of the corresponding items.
#' @export
#'
#' @examples
#' items_name(id = "mydata")

items_name <- function(id){paste0(id, "_items")}
