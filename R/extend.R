

#' Extend Item
#'
#' @description
#' Add specific attribute(s) with fine tuning.
#'
#' @param config the config object.
#' @param item optional (see details), the name (id) of the item group.
#' @param ... one or several attribute instructions.
#'
#' @details
#' This function is a wrapper around design() to provide a comprehensive
#' layered syntax.
#'
#' It only understands the `attribute` instruction inside `...`:
#' attribute = c(name = "note", type = "character")
#' Anything else will be filtered.
#'
#' When `item` is set in the parent frame, then the attribute can be skipped
#' in the function call.
#'
#' @seealso [parent.frame()]
#'
#' @returns a config list()
#' @export
#'
#' @examples
#' # create config
#' config <- design(project = "test",
#'         item = "foo")
#'
#' # set item (to skip it in following calls)
#' item <- "foo"
#'
#' # extend
#' config |>
#'   extend(attribute = c(name = "date", type = "Date", default = "Sys.Date()"))
#'
#' # is same as
#' config <- design(project = "test",
#'         item = "foo",
#'         attribute = c(name = "date", type = "Date", default = "Sys.Date()"))

extend <- function(config, item = get_context(), ...){

  # -- call design
  # secure from funny instructions
  # merge item inside attribute vector
  do.call(design, c(list(config),
                    lapply(list(...)[names(list(...)) == "attribute"],
                           append,
                           c(item = item))))

}
