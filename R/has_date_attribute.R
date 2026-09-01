

#' Has Date
#'
#' @description
#' Basic check if item has a 'date' attribute.
#'
#' @param config the config list
#' @param item optional (see details), the name (id) of the item group
#'
#' @details
#' When `item` is set in the parent frame, then the attribute can be skipped
#' in the function call.
#'
#' @seealso [parent.frame()]
#'
#' @returns a logical
#' @export
#'
#' @examples
#' has_date(design(project = "test))

has_date_attribute <- function(config, item = get_context()){

  "date" %in% names(config_item_colclasses(config, item))

}
