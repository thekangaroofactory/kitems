

#' Kitems Admin Console
#'
#' @description
#' Launches the administration console (Shiny App)
#'
#' @param path the path where to find item folder(s)
#'
#' @details
#' The app will scan the path to detect sub folders that are expected to be
#' item folders named after the id used to create them.
#'
#' It will build the ui from this list.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' admin()
#' }

# -- function definition
admin <- function(path = getwd()) {

  # -- get app path
  appDir <- system.file("R", package = "kitems")

  # -- check30
  if(appDir == "")
    stop("Could not find R directory. Try re-installing `kitems`.", call. = FALSE)

  # -- set option (the app will get it)
  shiny::shinyOptions(kitems_path = path)

  # -- run app
  shiny::runApp(file.path(appDir, "admin_console.R"), display.mode = "normal")

}
