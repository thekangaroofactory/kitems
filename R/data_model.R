

#' Build data model
#'
#' @param colClasses a \emph{mandatory} named vector of classes, defining the data model.
#' @param default.val an optional named vector of values, defining the default values.
#' @param default.fun an optional named vector of functions, defining the default functions to be used to generate default values.
#' @param default.arg an optional named vector of arguments, to pass along with the default function.
#' @param filter an optional character vector, indicating which attribute names should be filtered from the table view.
#' @param skip an optional character vector, indicating which attribute names should be skipped from the user input form.
#'
#' @return a data.frame containing the data model.
#'
#' @export
#'
#' @details
#' colClasses will be used to create the data.frame: names will define the attributes of the data model,
#' and values will define the class (type) of the attributes.
#'
#' All default.* parameters are optional. When provided, they will be used to match with names defined in colClasses:
#' - order in those vectors doesn't matter
#' - there is no need to set values for all attributes (see examples)
#' - names in vectors not matching with colClasses names will be ignored
#'
#' default.fun and default.val are mutual exclusive, with priority on default.fun (default.val will be forced to NA)
#' default.arg requires default.fun not to be NULL (will be forced to NA otherwise)
#'
#' filter and skip directly contains the names of the attributes to set to TRUE
#'
#' If not provided, defaults will be applied:
#' - NA for default.val, default.fun and default.arg
#' - FALSE for filter and skip
#'
#' @examples
#' # order in vectors doesn't matter:
#' default.val <- c("name" = "test", "total" = 2)
#' default.val <- c("total" = 2, "name" = "test")
#'
#' # no need to set all values
#' colClasses <- c("id" = "numeric", "name" = "character", "total" = "numeric")
#' default.val <- c("name" = "test", "total" = 2)
#'
#' # filter and skip
#' filter <- "id"
#' skip <- c("id", "date") for example
#'
#' data_model(colClasses, default.val, filter = filter, skip = skip)
#'

data_model <- function(colClasses, default.val = NULL, default.fun = NULL, default.arg = NULL, filter = NULL, skip = NULL){

  # -- check arg #217
  if(is.null(names(colClasses)))
    stop("colClasses must be a named vector")

  # -- make sure default.val & fun are mutual exclusive
  if(any(names(default.val) %in% names(default.fun)))
    default.val <- default.val[!names(default.val) %in% names(default.fun)]


  # -- Build data.frame from colClasses (named vector)
  dm <- data.frame("name" = names(colClasses), "type" = unname(colClasses))

  # -- Add default.val (match input with names)
  if(isTruthy(default.val))
    dm$default.val <- as.character(default.val[match(dm$name, names(default.val))])
  else
    dm$default.val <- NA

  # -- Add default.fun (match input with names)
  if(isTruthy(default.fun))
    dm$default.fun <- as.character(default.fun[match(dm$name, names(default.fun))])
  else
    dm$default.fun <- NA

  # -- Add default.arg (match input with names)
  if(isTruthy(default.arg))
    dm$default.arg <- as.character(default.arg[match(dm$name, names(default.arg))])
  else
    dm$default.arg <- NA

  # -- Add filter (match input with names)
  dm$filter <- dm$name %in% filter

  # -- Add skip (match input with names)
  dm$skip <- dm$name %in% skip

  # -- Return
  dm

}
