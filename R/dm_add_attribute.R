

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
#'
#' @return the updated data model
#' @export
#'
#' @seealso [data_model()]
#'
#' @examples
#' \dontrun{
#' dm_add_attribute(data.model = mydatamodel, name = "new_attribute", type = "character")
#' dm_add_attribute(data.model = mydatamodel, name = "total", type = "numeric", default.val = 0)
#' dm_add_attribute(data.model = mydatamodel, name = "date", type = "Date", default.fun = "Sys.Date")
#' dm_add_attribute(data.model = mydatamodel, name = "progress", type = "integer", skip = "progress")
#' dm_add_attribute(data.model = mydatamodel, name = "internal", type = "logical", filter = "internal")
#' }


dm_add_attribute <- function(data.model, name, type, default.val = NULL, default.fun = NULL, default.arg = NULL, filter = NULL, skip = NULL){

  cat("[dm_add_attribute] Add attribute to data model =", name, "\n")

  # -- Init attribute (using data_model to fit with structure)
  new_attribute <- data_model(colClasses = stats::setNames(type, name),
                              default.val = default.val,
                              default.fun = default.fun,
                              default.arg = default.arg,
                              filter = filter,
                              skip = skip)

  # -- Merge to data.model (return)
  data.model <- rbind(data.model, new_attribute)

}
