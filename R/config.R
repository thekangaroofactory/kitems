

#' Create YAML Configuration File
#'
#' @param project a character string to indicate the name of the project
#'
#' @returns a list
#' @export
#'
#' @examples
#' config_create(project = "my_project")

config_create <- function(project){

  # -- return
  list(
    version = as.character(packageVersion("kitems")),
    project = project)

}


#' Item Config
#'
#' @description
#' Helper function to create the config section for an item.
#'
#' @param id a character string to set the name of the item group
#' @param path a character string where to find the data
#'
#' @returns a list
#' @export
#'
#' @examples
#' config_item(id = "foo", path = "./")

config_item <- function(id, path){

  list(id = id,
       source = list(type = "file",
                     path = path))

}
