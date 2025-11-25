

#' Run Shiny Demo Apps
#'
#' @param example a character value, with the name of the demo to be launched.
#'
#' @details
#' When \code{example} is `NA`, the function will return the names of available apps.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' runExample()
#' }

runExample <- function(example = NA) {

  # -- check argument
  if(is.na(example)){

    # -- get list of apps
    appDir <- system.file("shiny-examples", package = "kitems")
    apps <- list.dirs(appDir, recursive = F, full.names = F)

    print("Available examples:")
    return(apps)}


  # -- get app path
  appDir <- system.file("shiny-examples", example, package = "kitems")

  # -- check
  if (appDir == "")
    stop("Could not find example directory. Check available examples with runExample().", call. = FALSE)

  # -- run app
  shiny::runApp(appDir, display.mode = "normal")

}
