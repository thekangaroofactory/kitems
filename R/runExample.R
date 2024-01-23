

#' Run the shiny demo app
#'
#' @export
#'
#' @examples
#' runExample()

runExample <- function() {

  # -- get app path
  appDir <- system.file("shiny-examples", "demo", package = "kitems")

  # -- check
  if (appDir == "")
    stop("Could not find example directory. Try re-installing `kitems`.", call. = FALSE)

  # -- run app
  shiny::runApp(appDir, display.mode = "normal")

}
