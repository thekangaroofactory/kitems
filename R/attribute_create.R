

#' Add attribute to a data model
#'
#' @param data.model a \emph{mandatory} data model, structured as an output of data_model() function
#' @param name a \emph{mandatory} character string for the new attribute name
#' @param type a \emph{mandatory} character string for the new attribute type
#' @param default.val an optional named vector of values, defining the default values.
#' @param default.fun an optional named vector of functions, defining the default functions to be used to generate default values.
#' @param default.arg an optional named vector of arguments, to pass along with the default function.
#' @param skip an optional character vector, with the name(s) of the attribute(s) to skip
#' @param filter an optional character vector, with the name(s) of the attribute(s) to filter
#' @param sort.rank an optional named numeric vector, to define sort orders
#' @param sort.desc an optional named logical vector, to define if sort should be descending
#'
#' @return the updated data model
#' @export
#'
#' @seealso [data_model()]
#'
#' @examples
#' \dontrun{
#' attribute_create(data.model = mydatamodel, name = "new_attribute", type = "character")
#' attribute_create(data.model = mydatamodel, name = "total", type = "numeric", default.val = 0)
#' attribute_create(data.model = mydatamodel, name = "date", type = "Date", default.fun = "Sys.Date")
#' attribute_create(data.model = mydatamodel, name = "progress", type = "integer", skip = "progress")
#' attribute_create(data.model = mydatamodel, name = "internal", type = "logical", filter = "internal")
#' }


attribute_create <- function(data.model, name, type,
                             default.val = NULL, default.fun = NULL, default.arg = NULL,
                             filter = NULL, skip = NULL,
                             sort.rank = NULL, sort.desc = NULL){

  catl("Add attribute to data model =", name)

  # -- Init attribute (using data_model to fit with structure)
  new_attribute <- data_model(colClasses = stats::setNames(type, name),
                              default.val = default.val,
                              default.fun = default.fun,
                              default.arg = default.arg,
                              filter = filter,
                              skip = skip,
                              sort.rank = sort.rank,
                              sort.desc = sort.desc)

  # -- Merge to data.model (return)
  data.model <- dplyr::bind_rows(data.model, new_attribute)

}
