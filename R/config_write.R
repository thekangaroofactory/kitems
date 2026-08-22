

#' Write YAML config file
#'
#' @param x a list object to write to YAML
#' @param path where to store the _kitems YAML file
#'
#' @details
#' By default, `path` uses the R_KITEMS_PATH environment variable.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' config_write(list(foo = 1, bar = "two"))
#' }

config_write <- function(x, path = Sys.getenv("R_KITEMS_PATH")){

  # -- check
  if(!dir.exists(path))
    stop("Path ", path, " does not exist!")

  # -- write YAML
  yaml::write_yaml(x,
                   file = file.path(path, "_kitems.yml"),
                   indent = 4,
                   handlers = list(logical = yaml::verbatim_logical))

}
