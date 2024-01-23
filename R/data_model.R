

#' Build data model
#'
#' @param colClasses a \emph{mandatory} named vector of classes, defining the data model.
#' @param default.val an optional named vector of values, defining the default values.
#' @param default.fun an optional named vector of functions, defining the default functions to be used to generate default values.
#' @param filter an optional named vector of logical, indicating whether or not the attribute should be filtered from the table view.
#' @param skip an optional named vector of logical, indicating whether or not the attribute should be skipped from the user input form.
#'
#' @return a data.frame containing the data model.
#'
#' @export
#'
#' @details
#' colClasses will be used to create the data.frame: names will define the attributes of the data model,
#' and values will define the class (type) of the attributes.
#'
#' All other parameters are optional. When provided, they will be used matching names defined in colClasses, so:
#' - order in those vectors doesn't matter,
#' - no need to set values for all attributes (see examples),
#' - names in those vectors not matching with colClasses names will be ignored.
#' If not provided, defaults will be applied:
#' - NA for default.val and default.fun,
#' - FALSE for filter and skip.
#'
#' @examples
#' data_model(colClasses, default.val, default.fun)
#'
#' # order in vectors doesn't matter:
#' default.val <- c("name" = "test", "total" = 2)
#' default.val <- c("total" = 2, "name" = "test")
#'
#' no need to set all values
#' colClasses <- c("id" = "double", "name" = "character", "total" = "numeric")
#' default.val <- c("name" = "test", "total" = 2)
#'


data_model <- function(colClasses, default.val = NULL, default.fun = NULL, filter = NULL, skip = NULL){

  cat("[data_model] Building data model \n")

  # -- Build data.frame from colClasses (named vector)
  dm <- data.frame("name" = names(colClasses), "type" = unname(colClasses))

  # -- Add default.val (match input with names)
  if(!is.null(default.val))
    dm$default.val <- default.val[match(dm$name, names(default.val))]
  else
    dm$default.val <- NA

  # -- Add default.fun (match input with names)
  if(!is.null(default.fun))
    dm$default.fun <- default.fun[match(dm$name, names(default.fun))]
  else
    dm$default.fun <- NA

  # -- Add filter (match input with names)
  dm$filter <- dm$name %in% filter

  # -- Add skip (match input with names)
  dm$skip <- dm$name %in% skip

  # -- Return
  dm

}


