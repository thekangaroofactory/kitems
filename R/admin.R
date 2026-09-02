

#' Admin Console
#'
#' @description
#' Launches the administration console (Shiny App)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # set environment (where to find the _kitems.yml)
#' Sys.setenv("R_KITEMS_PATH" = "D:/data")
#'
#' # launch the Admin Console
#' admin()
#' }

admin <- function() {

  # -- check env
  if(Sys.getenv("R_KITEMS_PATH") == "")
    stop("Set R_KITEMS_PATH environment variable to where the _kitems.yml file is.", call. = F)

  # -- app path
  appDir <- system.file("R", package = "kitems")
  if(appDir == "")
    stop("Could not find R folder. Try re-installing `kitems`.", call. = FALSE)

  # -- run app
  shiny::runApp(file.path(appDir, "admin_console.R"), display.mode = "normal")

}
