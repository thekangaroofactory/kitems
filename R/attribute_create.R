

#' Add Attribute
#'
#' @description
#' Add an attribute to a data model
#'
#' @param data.model a data model data.frame, structured as an output of the `data_model()` function
#' @param name a character vector for the new attribute name
#' @param type a character vector for the new attribute type
#' @param default.val an optional named vector of values, defining the default values.
#' @param default.fun an optional named vector of functions, defining the default functions to be used to generate default values.
#' @param default.arg an optional named vector of arguments, to pass along with the default function.
#' @param skip an optional character vector, with the name(s) of the attribute(s) to skip
#' @param display an optional character vector, with the name(s) of the attribute(s) to display
#' @param sort.rank an optional named numeric vector, to define sort orders
#' @param sort.desc an optional named logical vector, to define if sort should be descending
#'
#' @return The updated data model data.frame
#' @export
#'
#' @details
#' Multiple attribute creation is supported, in this case make sure all vectors have same length.
#'
#' When `data.model` is omitted, the function will return a data model containing the created attributes.
#'
#' @seealso [data_model()]
#'
#' @examples
#' \dontrun{
#'
#' # -- create single attribute
#' attribute_create(name = "new_attribute", type = "character")
#' attribute_create(name = "total", type = "numeric", default.val = 0)
#' attribute_create(name = "date", type = "Date", default.fun = "Sys.Date")
#' attribute_create(name = "progress", type = "integer", skip = "progress")
#' attribute_create(name = "internal", type = "logical", display = "internal")
#'
#' # -- create multiple attributes
#' attribute_create(name = c("foo", "bar"), type = c("character", "numeric"))
#'
#' }

attribute_create <- function(data.model = NULL, name, type,
                             default.val = NULL, default.fun = NULL, default.arg = NULL,
                             display = NULL, skip = NULL,
                             sort.rank = NULL, sort.desc = NULL){

  catl("Add attribute to data model =", name)

  # -- Init attribute (using data_model to fit with structure)
  new_attribute <- data_model(colClasses = stats::setNames(type, name),
                              default.val = default.val,
                              default.fun = default.fun,
                              default.arg = default.arg,
                              display = display,
                              skip = skip,
                              sort.rank = sort.rank,
                              sort.desc = sort.desc)

  # -- Merge & return
  dplyr::bind_rows(data.model, new_attribute)

}
