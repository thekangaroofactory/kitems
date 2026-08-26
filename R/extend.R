

#' Extend Item
#'
#' @description
#' Add specific attribute(s) with fine tuning.
#'
#' @param config the config object
#' @param item the name (id) of the item to extend
#' @param ... one or several attribute instructions
#'
#' @details
#' This function is a wrapper around design() to provide a comprehensive
#' layered syntax.
#'
#' @returns a config list()
#' @export
#'
#' @examples
#' design(project = "test",
#         item = "foo") |>
#         extend(item = "foo",
#                attribute = c(name = "date", type = "Date", default = "Sys.Date()"))


extend <- function(config, item, ...){

  # -- call design
  # secure from funny instructions
  # merge item inside attribute vector
  do.call(design, c(list(config),
                    lapply(list(...)[names(list(...)) == "attribute"],
                           append,
                           c(item = item))))

}
