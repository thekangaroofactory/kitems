

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
