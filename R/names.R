

#' Data Model Name & URL
#'
#' @description
#' Helper functions to compute the data model name and URL.
#'
#' @param id the id of the module server instance.
#' @param path the path to the data model and items.
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' These functions are kept for backward compatibility reasons.
#' (backup / restore before migration).
#'
#' @return The name or url of the data model.
#' @export
#'
#' @examples
#' dm_name(id = "mydata")
#' dm_url(id = "mydata")

dm_name <- function(id){paste0(id, "_data_model")}

#' @rdname refresh
#' @export

dm_url <- function(id, path = Sys.getenv("R_KITEMS_PATH")){file.path(path, paste0(dm_name(id), ".rds"))}


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


#' Items URL
#'
#' @param id the id of the module server instance.
#' @param path the path to the data model and items.
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' @returns The URL of the items
#' @export
#'
#' @examples
#' items_url(id = "mydata")

items_url <- function(id, path = Sys.getenv("R_KITEMS_PATH")){file.path(path, paste0(items_name(id), ".csv"))}
