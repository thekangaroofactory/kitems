

#' Amend Attribute
#'
#' @description
#' Update specific parameter(s) of specific attribute(s)).
#'
#' @param config the config list.
#' @param item optional (see details), the name (id) of the item group.
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
#' When `item` is set in the parent frame, then the attribute can be skipped
#' in the function call.
#'
#' @seealso [parent.frame()]
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
#' # skip item argument (in the following calls)
#' item <- "foo"
#'
#' # single instruction
#' config |>
#'   amend(attribute = c(name = "total", default = 12))
#' config |>
#'   amend(attribute = c(name = "total", values = "suggest(12)"))
#'
#' # multiple instructions
#' config |>
#'   amend(attribute = c(name = "total", values = "suggest(12)"),
#'         attribute = c(name = "total", default = "0"))

amend <- function(config, item = get_context(), ...){

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
  x <- c_extract(config, item, attribute = args$attribute['name'])

  # -- create new attribute
  # secure against name & type update
  new <- do.call(ca_create,
                 c(list(name = args$attribute[['name']],
                        type = x$type),
                   args$attribute[!names(args$attribute) %in% c("name", "type")]))

  # -- update attribute
  x[names(new)] <- new
  ca_update(config, item, attribute = x)

}
