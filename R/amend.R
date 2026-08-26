

#' Amend Attribute
#'
#' @description
#' Update specific parameter(s) of specific attribute(s)).
#'
#' @param config the config list.
#' @param item the name (id) of the targeted item.
#' @param ... one or several attribute instructions.
#'
#' @details
#' The function only understands `attribute` instruction.
#' It can handle multiple instructions in `...`.
#'
#' Note that it is forbidden to update:
#' - the id attribute (any parameter),
#' - the name and/or type of an attribute.
#'
#' @returns a config list
#' @export
#'
#' @examples
#' # create baseline
#' config <- design(project = "test",
#'                  item = "foo") |>
#'   extend(item = "foo",
#'          attribute = c(name = "total", type = "integer"))
#'
#' # single instruction
#' config |>
#'   amend(item = "foo", attribute = c(name = "total", default = 12))
#' config |>
#'   amend(item = "foo", attribute = c(name = "total", values = "suggest(12)"))
#'
#' # multiple instructions
#' config |>
#'   amend(item = "foo",
#'         attribute = c(name = "total", values = "suggest(12)"),
#'         attribute = c(name = "total", default = "0"))

amend <- function(config, item, ...){

  # -- get instruction
  # secure against funny instructions
  args <- list(...)[names(list(...)) == "attribute"]

  # ////////////////////////////////////////////////////////////////////////////
  # Check for multiple expressions

  if(length(args) > 1){

    # -- loop over instructions (recursive call)
    for(i in 1:length(args))
      config <- do.call(amend,
                        append(list(config, item), args[i]))

    # -- make sure we don't go further
    return(config)}


  # ////////////////////////////////////////////////////////////////////////////
  # Update attribute

  # -- get attribute
  x <- config_extract(config, item, attribute = args$attribute['name'])

  # -- create new attribute
  # secure against name & type update
  new <- do.call(config_attribute_create,
                 c(list(name = args$attribute[['name']],
                        type = x$type),
                   args$attribute[!names(args$attribute) %in% c("name", "type")]))

  # -- update attribute
  x[names(new)] <- new
  config_attribute_update(config, item, attribute = x)

}
