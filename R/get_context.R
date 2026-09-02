

#' Default Item Context
#'
#' @description
#' Helper function to provide a contextual default value.
#'
#' @details
#' Since the project YAML config has been introduced (v0.8.0), all core functions
#' require to provide the name (id) of the item group to manipulate.
#'
#' At the grammar level functions, this argument needs to be collected to pass
#' it's value to the core level functions.
#'
#' When used inside the module server (one instance is dedicated to a specific item group)
#' or any custom code applied to a single item group, it would be tidious
#' to repeat this argument with the same value for each call.
#'
#' By setting item = get_context(), the argument will get it's value from the
#' environment in which the function was called.
#'
#' @returns a character value or NULL
#'
#' @examples
#' # baseline
#' config <- design(project = "test", item = "foo")
#'
#' # instead of
#' config |> extend(item = "foo", attribute = c(name = "total", type = "integer"))
#'
#' # one can do
#' item <- "foo"
#' config |> extend(attribute = c(name = "total", type = "integer"))

get_context <- function(){

  parent.frame(n =2)$item

}
