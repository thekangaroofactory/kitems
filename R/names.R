

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
