

#' Read YAML config file
#'
#' @param path where to find _kitems.yml
#'
#' @details
#' By default, `path` uses the R_KITEMS_PATH environment variable.
#'
#' @returns a list or NULL if no file is found.
#' @export
#'
#' @examples
#' config_read()

config_read <- function(path = Sys.getenv("R_KITEMS_PATH")){

  # -- search file
  config_file <- list.files(path, pattern = "_kitems.yml", full.names = T)

  # -- return
  if(length(config_file)){

    catl("Reading YAML file", config_file, level = 1)
    yaml::read_yaml(file = config_file)

  } else NULL

}

# yaml::write_yaml(dm, file = "D:/Downloads/_kitems_update.yml", indent = 4, handlers = list(logical = yaml::verbatim_logical))
