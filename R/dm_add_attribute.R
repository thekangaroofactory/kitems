

#' Add attribute to a data model
#'
#' @param data.model a \emph{mandatory} data model, structured as an output of data_model() function
#' @param name a \emph{mandatory} character string for the new attribute name
#' @param type a \emph{mandatory} character string for the new attribute type
#' @param default.val an optional default value
#' @param default.fun an optional default function
#' @param skip an optional logical value (default = FALSE) if the attribute should be skipped in the input form
#' @param filter an optional logical value (default = FALSE) if the attribute should be masked in the filtered view
#'
#' @return the updated data model
#' @export
#'
#' @examples
#' \dontrun{
#' dm_add_attribute(data.model = mydatamodel, name = "new_attribute", type = "character")
#' dm_add_attribute(data.model = mydatamodel, name = "total", type = "numeric", default.val = 0)
#' dm_add_attribute(data.model = mydatamodel, name = "date", type = "Date", default.fun = "Sys.Date")
#' dm_add_attribute(data.model = mydatamodel, name = "progress", type = "integer", skip = TRUE)
#' dm_add_attribute(data.model = mydatamodel, name = "internal", type = "logical", filter = TRUE)
#' }


dm_add_attribute <- function(data.model, name, type, default.val = NA, default.fun = NA, skip = FALSE, filter = FALSE){

  cat("[dm_add_attribute] Add attribute to data model \n")

  # -- Check for empty strings (data.frame would fail)
  if(identical(default.val, ""))
    default.val <- NA

  if(identical(default.fun, ""))
    default.fun <- NA

  # -- make sure default.val & fun are mutual exclusive #230
  if(!is.na(default.fun))
    default.val <- NA

  # -- Check for NULL
  if(is.null(skip))
    skip <- FALSE

  if(is.null(filter))
    filter <- FALSE

  # -- Init attribute
  new_attribute <- data.frame(name = name,
                              type = type,
                              default.val = default.val,
                              default.fun = default.fun,
                              skip = skip,
                              filter = filter)

  # -- Merge to data.model (return)
  data.model <- rbind(data.model, new_attribute)

}
