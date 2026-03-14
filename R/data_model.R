

#' Data Model
#'
#' @description
#' Build a data model or an attribute.
#'
#' @param colClasses a \emph{mandatory} named vector of classes, defining the data model.
#' @param class.arg an optional named vector of arguments, to pass along with the class function (see details).
#' @param default.val an optional named vector of values, defining the default values.
#' @param default.fun an optional named vector of functions, defining the default functions to be used to generate default values.
#' @param default.arg an optional named vector of arguments, to pass along with the default function.
#' @param display an optional character vector, indicating which attribute names should be displayed in the table view.
#' @param skip an optional character vector, indicating which attribute names should be skipped from the user input form.
#' @param refresh an optional named logical vector, to indicate if skipped attributes should be updated (see details).
#' @param sort.rank an optional named numeric vector, to define sort orders.
#' @param sort.desc an optional named logical vector, to define if sort should be descending.
#'
#' @return A data.frame containing the data model or the attribute.
#'
#' @export
#'
#' @details
#' Unless it is called from the `attribute_create()` function, it will return a data.model.
#' This is because a standalone attribute has no reason to exist.
#'
#' `colClasses` will be used to create the data.frame: names will define the attributes of the data model,
#' and values will define the class of the attributes.
#' When creating a data model, the id attribute will be added if it's missing from `colClasses`.
#' When `class.arg` is set, it will be sent along with the as.* conversion function call.
#' Ex: as.POSIXct("2025-09-10T13:16:55Z", format = "%Y-%m-%dT%H:%M:%S")
#'
#' All `default.*` parameters are optional. When provided, they will be used to match with names defined in colClasses:
#' - order in those vectors doesn't matter
#' - there is no need to set values for all attributes (see examples)
#' - names in vectors not matching with colClasses names will be ignored
#'
#' `default.fun` and `default.val` are mutual exclusive, with priority on `default.fun` (`default.val` will be forced to \code{NA})
#' `default.arg` requires `default.fun` not to be NULL (will be forced to \code{NA} otherwise)
#'
#' `display` and `skip` directly contains the names of the attributes to set to TRUE
#'
#' Attributes with `skip` set to TRUE will be ignored by default when an item is updated. To force the computation of a new
#' value (based on the default parameters), set `refresh` to TRUE as well.
#'
#' If not provided, defaults will be applied:
#' - \code{NA} for `default.val`, `default.fun` and `default.arg`
#' - \code{FALSE} for `display`, `skip` and `refresh`
#'
#' @examples
#' # -- order in vectors doesn't matter:
#' default.val <- c("name" = "test", "total" = 2)
#' default.val <- c("total" = 2, "name" = "test")
#'
#' # -- no need to set all values
#' colClasses <- c("id" = "numeric", "name" = "character", "total" = "numeric")
#' default.val <- c("name" = "test", "total" = 2)
#'
#' # -- display and skip
#' display <- "id"
#' skip <- c("id", "date")
#'
#' # -- sort
#' sort.rank = c("date" = 1, "total" = 2, "name" = 3)
#' sort.desc = c("date" = TRUE, "total" = FALSE)
#'
#' data_model(colClasses, default.val, display = display, skip = skip)
#'

data_model <- function(colClasses, class.arg = NULL,
                       default.val = NULL, default.fun = NULL, default.arg = NULL,
                       display = NULL, skip = NULL, refresh = NULL,
                       sort.rank = NULL, sort.desc = NULL){

  # -- check arg #217
  if(is.null(names(colClasses)))
    stop("colClasses must be a named vector")

  # -- check call stack
  # function will output a data.model or attribute
  if(deparse(sys.call(-1)[[1L]]) != "attribute_create"){

    # -- this should be replaced by values from TEMPLATE_DATA_MODEL
    if(!"id" %in% names(colClasses)){
      warning("Adding missing id attribute")
      colClasses <- c(c(id = "numeric"), colClasses)
      default.fun <- c(c(id = "ktools::getTimestamp"), default.fun)
      default.arg <- c(c(id = "list(k=1000000)"), default.arg)
      skip <- c("id", skip)}}

  # -- make sure default.val & fun are mutual exclusive
  if(any(names(default.val) %in% names(default.fun)))
    default.val <- default.val[!names(default.val) %in% names(default.fun)]


  # -- Build data.frame from colClasses (named vector)
  x <- data.frame("name" = names(colClasses), "type" = unname(colClasses))

  # -- Add class.arg (match input with names)
  if(isTruthy(class.arg))
    x$class.arg <- as.character(class.arg[match(x$name, names(class.arg))])
  else
    x$class.arg <- NA

  # -- Add default.val (match input with names)
  if(isTruthy(default.val))
    x$default.val <- as.character(default.val[match(x$name, names(default.val))])
  else
    x$default.val <- NA

  # -- Add default.fun (match input with names)
  if(isTruthy(default.fun))
    x$default.fun <- as.character(default.fun[match(x$name, names(default.fun))])
  else
    x$default.fun <- NA

  # -- Add default.arg (match input with names)
  if(isTruthy(default.arg))
    x$default.arg <- as.character(default.arg[match(x$name, names(default.arg))])
  else
    x$default.arg <- NA

  # -- Add display (match input with names)
  x$display <- x$name %in% display

  # -- Add skip & refresh (match input with names)
  x$skip <- x$name %in% skip
  x$refresh <- x$name %in% refresh

  # -- Add sort.rank (match input with names)
  if(isTruthy(sort.rank))
    x$sort.rank <- as.numeric(sort.rank[match(x$name, names(sort.rank))])
  else
    x$sort.rank <- NA

  # -- Add sort.desc (match input with names)
  if(isTruthy(sort.desc))
    x$sort.desc <- as.logical(sort.desc[match(x$name, names(sort.desc))])
  else
    x$sort.desc <- NA

  # -- Add version
  attr(x, "version") <- as.character(utils::packageVersion("kitems"))

  # -- Return
  x

}
