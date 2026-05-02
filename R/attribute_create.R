

#' Add Attribute
#'
#' @description
#' Add an attribute to a data model
#'
#' @param data.model a data model, structured as an output of the `data_model()` function
#' @param name a character vector for the attribute name to add
#' @param class a character vector for the attribute class to add
#' @param ... further arguments passed to `data_model()`
#'
#' @return The updated data model (or `data.model` if it fails)
#' @export
#'
#' @details
#' Multiple attribute creation is supported.
#'
#' @seealso [data_model()]
#'
#' @examples
#' \dontrun{
#'
#' # -- Add single attribute
#' attribute_create(data.model = NULL, name = "new_attribute", class = "character")
#' attribute_create(data.model = NULL, name = "total", class = "numeric", default = 0)
#' attribute_create(data.model = NULL, name = "date", class = "Date", default = "Sys.Date()")
#' attribute_create(data.model = NULL, name = "progress", class = "integer", skip = "progress")
#' attribute_create(data.model = NULL, name = "internal", class = "logical", display = "internal")
#'
#' # -- create multiple attributes
#' attribute_create(data.model = NULL, name = c("foo", "bar"), class = c("character", "numeric"))
#'
#' }

attribute_create <- function(data.model = NULL, name, class, ...){

  catl("Add attribute to data model =", name)

  # -- secure against errors
  tryCatch(

    dplyr::bind_rows(data.model,
                     data_model(colClasses = stats::setNames(class, name), ...)),

    error = function(e){

      warning("An error occured, returning the source data.model\n", e$message)
      return(data.model)}

  )

}
