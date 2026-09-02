

#' Config List To Table
#'
#' @description
#' Turn a config list into a data.frame
#'
#' @param config the config list (see details).
#' @param ... the columns to include in the output.
#' @param item optional (see details), the name (id) of the item group.
#'
#' @details
#' The function is used as a bridge between the config list structure and
#' the expected data.frame input argument for some functions.
#' It also helps to keep / select the desired columns (see example).
#'
#' By default, `config` is the global project config list.
#' `item` is required in this case unless it is already set in the parent
#' frame.
#'
#' In case the item level config list is provided, it should be up to
#' the data.model's level. Make sure to explicitly set `ìtem = NULL` if
#' it is set in the parent frame.
#'
#' @returns a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' # get data.model with name and default
#' yaml_to_dm(config, name, default, item = "foo")
#' }

yaml_to_dm <- function(config, ..., item = get_context()){

  # -- item data.model
  if(!is.null(item))
    config <- config_extract(config, item)$data.model

  # -- get expected column(s)
  cols <- sapply(rlang::ensyms(...), rlang::as_name)

  # -- return
  dplyr::bind_rows(config$attributes) |>
    dplyr::select(dplyr::any_of(cols))

}
