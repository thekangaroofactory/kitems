

#' Admin Console
#'
#' @description
#' Launches the administration console (Shiny App)
#'
#' @param path where to find the data model & item folder(s)
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' The app will scan `path` to detect sub folders that are expected to be
#' item folders named after the id used to create them.
#'
#' It will build the ui tabs from this list.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' admin()
#' }

# -- function definition
admin <- function(path = Sys.getenv("R_KITEMS_PATH")) {

  # -- get app path
  appDir <- system.file("shiny", package = "kitems")

  # -- check30
  if(appDir == "")
    stop("Could not find shiny directory. Try re-installing `kitems`.", call. = FALSE)

  # -- set option (the app will get it)
  shiny::shinyOptions(kitems_path = path)

  # -- run app
  shiny::runApp(file.path(appDir, "admin_console.R"), display.mode = "normal")

}
