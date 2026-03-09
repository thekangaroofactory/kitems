

#' Admin Console
#'
#' @description
#' Launches the administration console (Shiny App)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' admin()
#' }

admin <- function() {

  # -- get app path
  appDir <- system.file("shiny", package = "kitems")

  # -- check30
  if(appDir == "")
    stop("Could not find shiny folder. Try re-installing `kitems`.", call. = FALSE)

  # -- run app
  shiny::runApp(file.path(appDir, "admin_console.R"), display.mode = "normal")

}
