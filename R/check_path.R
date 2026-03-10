

#' Check Path Argument
#'
#' @param path the value to check
#'
#' @returns NULL if all checks are ok

check_path <- function(path){

  # -- check value
  stopifnot("path can't be NULL, set R_KITEMS_PATH environment variable" = !is.null(path))
  stopifnot("path is empty, set R_KITEMS_PATH environment variable" = path != "")

  # -- check variable
  if(path != Sys.getenv("R_KITEMS_PATH"))
    message("It is recommended to use R_KITEMS_PATH environment variable to define the path")

  # -- check if exist
  stopifnot("path does not exist, check R_KITEMS_PATH environment variable" = dir.exists(path))

}
