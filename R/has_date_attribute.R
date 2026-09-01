

#' Has Date
#'
#' @description
#' Basic check if item has a 'date' attribute.
#'
#' @param config the config list
#' @param item the name (id) of the item group
#'
#' @returns a logical
#' @export
#'
#' @examples
#' has_date(design(project = "test))

has_date_attribute <- function(config, item){

  "date" %in% names(config_item_colclasses(config, item))

}
