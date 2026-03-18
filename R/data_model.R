

#' Data Model
#'
#' @description
#' Build a data model or an attribute.
#'
#' @param colClasses a names vector of classes, defining the data model.
#' @param class.arg optional named vector of arguments, to pass along with the class function (see details).
#' @param default.val optional named vector of default values.
#' @param default.fun optional named vector of default functions to be used to generate default values.
#' @param default.arg optional named vector of arguments, to pass along with the default function.
#' @param display optional logical value, if the attributes should be displayed in the table view.
#' @param skip optional logical value, if the attributes should be skipped from the user input form.
#' @param refresh optional logical value, if skipped attributes should be updated (see details).
#' @param sort.rank optional named integer vector, to define sort orders.
#' @param sort.desc optional named logical vector, if sort should be descending.
#'
#' @return A data.frame containing the data model or the attribute.
#'
#' @export
#'
#' @details
#' Unless it is called from the `attribute_create()` function, it will return a data.model.
#' This is because a standalone attribute has no reason to exist.
#'
#' Parameters for this function are strictly checked against their expected class & shape.
#' This process may throw errors as it is considered not safe to guess what the user is trying to do.
#' Calls to this function should be wrapped into a `tryCatch()` expression.
#'
#' `colClasses` will be used to create the data model:
#' - names will define the attributes of the data model,
#' - values will define the class of the attributes.
#' When creating a data model, the id attribute will be added if it's missing from `colClasses`.
#' When `colClasses` is NULL, a data model with the id attribute will be returned.
#' When `class.arg` is set, it will be sent along with the as.* conversion function call.
#' Ex: as.POSIXct("2025-09-10T13:16:55Z", format = "%Y-%m-%dT%H:%M:%S")
#'
#' All `default.*` parameters are optional.
#' When provided, they will be used to match with names defined in colClasses:
#' - order in those vectors doesn't matter
#' - there is no need to set values for all attributes (see examples)
#' - names in vectors not matching with colClasses names will be ignored
#'
#' `default.fun` and `default.val` are mutual exclusive, with priority on `default.fun` (`default.val` will be ignored)
#' `default.arg` requires `default.fun` not to be NULL (will be ignored otherwise)
#'
#' `display`, `skip` and `refresh` only accept logical values (no vector).
#' For those attributes, it is expected that fine tuning will be done through the fine grain verbs (escape, show, hide).
#'
#' Attributes with `skip` set to TRUE will be ignored by default when an item is updated.
#' To force the computation of a new value (based on the default parameters), set `refresh` to TRUE as well.
#' When `skip` is not set (default = FALSE), `refresh` will be ignored
#'
#' If not provided, defaults will be applied:
#' - \code{NA} for `default.val`, `default.fun` and `default.arg`
#' - \code{TRUE} for `display`
#' - \code{FALSE} for `skip` and `refresh`
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
#' display <- TRUE
#' skip <- FALSE
#'
#' # -- sort
#' sort.rank = c("date" = 1L, "total" = 2L, "name" = 3L)
#' sort.desc = c("date" = TRUE, "total" = FALSE)
#'
#' data_model(colClasses, default.val, display = display, skip = skip)
#'

data_model <- function(colClasses = NULL, class.arg = NULL,
                       default.val = NULL, default.fun = NULL, default.arg = NULL,
                       display = TRUE, skip = FALSE, refresh = FALSE,
                       sort.rank = NULL, sort.desc = NULL){


  # ////////////////////////////////////////////////////////////////////////////

  # -- colClasses
  # check for init without attribute
  if(is.null(colClasses)){

    # force reset all parameters
    class.arg <- default.val <- default.fun <- default.arg <- sort.rank <- sort.desc <- NULL

  } else {

    # must be a named character vector
    if(!is.vector(colClasses, mode = "character") || is.null(names(colClasses)))
      stop("colClasses must be a named character vector")

    if(any(!colClasses %in% OBJECT_CLASS))
      stop("colClasses must be a supported class: ", paste(OBJECT_CLASS, collapse = " / "))}


  # ////////////////////////////////////////////////////////////////////////////

  # -- class.arg, default.fun, default.arg
  # must be a named character vector or a character value

  if(!is.null(class.arg))
    class.arg <- match_arg_t1(class.arg, colClasses, mode = "character")

  if(!is.null(default.fun))
    default.fun <- match_arg_t1(default.fun, colClasses, mode = "character")

  if(!is.null(default.arg))
    default.arg <- match_arg_t1(default.arg, colClasses, mode = "character")


  # ////////////////////////////////////////////////////////////////////////////

  # -- default.val
  # must be a named vector or value

  if(!is.null(default.val))
    default.val <- match_arg_t1(default.val, colClasses)

  # -- make sure default.val & default.fun are mutual exclusive
  # note: default.fun has priority over default.val
  if(any(names(default.val) %in% names(default.fun)))
    default.val <- default.val[!names(default.val) %in% names(default.fun)]


  # ////////////////////////////////////////////////////////////////////////////

  # -- display, skip, refresh
  # must be a logical value
  # note: it makes no sense to send a vector, use hide / show verbs instead

  display <- match_arg_t2(display, default = TRUE, advice = "hide or show")
  skip <- match_arg_t2(skip, advice = "skip")
  refresh <- if(skip) match_arg_t2(refresh, advice = "skip") else FALSE


  # ////////////////////////////////////////////////////////////////////////////

  # -- sort.rank
  # must be a named integer vector or integer value

  if(!is.null(sort.rank))
    sort.rank <- match_arg_t1(sort.rank, colClasses, mode = "integer")

  # -- sort.desc
  # must be a named logical vector or logical value

  if(!is.null(sort.desc))
    sort.desc <- match_arg_t1(sort.desc, colClasses, mode = "logical")


  # ////////////////////////////////////////////////////////////////////////////

  # -- check call stack
  # function will output a data.model or attribute
  # note: as long as specific function name is checked, this behavior can't be
  # triggered from a custom function
  # note: call in attribute_create is wrapped into tryCatch which makes it
  # tricky to get the function name

  if(is.null(rlang::caller_call(n = 1)) ||
     unlist(strsplit(toString(rlang::caller_call(n = 1)), split = ","))[1L] != "attribute_create"){

    # -- check id attribute
    if(!"id" %in% names(colClasses)){
      message("Adding missing id attribute")
      # -- add from template
      id <- TEMPLATE_ATTRIBUTES[TEMPLATE_ATTRIBUTES$name == "id", ]
      colClasses <- c(c(id = id$type), colClasses)
      default.fun <- c(c(id = id$default.fun), default.fun)
      default.arg <- c(c(id = id$default.arg), default.arg)
      display <- c(id$display, rep(display, length(colClasses) - 1))
      skip <- c(id$skip, rep(skip, length(colClasses) - 1))
      refresh <- c(id$refresh, rep(refresh, length(colClasses) - 1))}}


  # ////////////////////////////////////////////////////////////////////////////

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
  # drop names not in default.fun
  default.arg <- default.arg[names(default.arg) %in% names(default.fun)]
  if(isTruthy(default.arg))
    x$default.arg <- as.character(default.arg[match(x$name, names(default.arg))])
  else
    x$default.arg <- NA

  # -- Add display, skip & refresh
  x$display <- display
  x$skip <- skip
  x$refresh <- refresh

  # -- Add sort.rank (match input with names)
  if(isTruthy(sort.rank))
    x$sort.rank <- as.numeric(sort.rank[match(x$name, names(sort.rank))])
  else
    x$sort.rank <- NA

  # -- Add sort.desc (match input with names)
  # drop names not in sort.rank
  sort.desc <- sort.desc[names(sort.desc) %in% names(sort.rank)]
  # add missing sort.rank names (set to FALSE)
  missing <- names(sort.rank)[!names(sort.rank) %in% names(sort.desc)]
  sort.desc <- c(sort.desc, stats::setNames(rep(FALSE, length(missing)), missing))
  # use custom is_truthy because FALSE is fine!
  if(is_truthy(sort.desc))
    x$sort.desc <- as.logical(sort.desc[match(x$name, names(sort.desc))])
  else
    x$sort.desc <- NA

  # -- Add version
  attr(x, "version") <- as.character(utils::packageVersion("kitems"))

  # -- Return
  x

}
