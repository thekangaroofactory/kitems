

#' Shrink Config
#'
#' @details
#' Drop an item or an attribute from the config.
#'
#' @param config
#' @param ...
#'
#' @details
#'
#' Note that it is forbidden to delete the 'id' attribute of an item.
#'
#' @returns a config list.
#' @export
#'
#' @examples
#' # build baseline
#' config <- design(project = "test",
#' item = "foo") |>
#'   extend(item = "foo",
#'          attribute = c(name = "total", type = "integer"))
#'
#' # drop item
#' config |>
#'   shrink(item = "foo")
#'
#' # drop attribute
#' config |>
#'   shrink(attribute = c(item = "foo", name = "total"))
#'
#' # multiple instructions
#' config |>
#'   shrink(attribute = c(item = "foo", name = "total"),
#'          item = "foo")
#'
#'

shrink <- function(config, ...){

  # -- get instruction(s)
  # secure from funny ones
  args <- list(...)[names(list(...)) %in% c("item", "attribute")]


  # ////////////////////////////////////////////////////////////////////////////
  # Check for multiple expressions

  if(length(args) > 1){

    # -- loop over instructions (recursive call)
    for(i in 1:length(args))
      config <- do.call(shrink,
                        append(list(config), args[i]))

    # -- make sure we don't go further
    return(config)}


  # ////////////////////////////////////////////////////////////////////////////
  # Item

  if(names(args) == "item")
    return(config_item_drop(config,
                            item = args$item))


  # ////////////////////////////////////////////////////////////////////////////
  # Attribute

  if(names(args) == "attribute")
    config_attribute_drop(config,
                          item = args$attribute['item'],
                          attribute = args$attribute['name'])

}
