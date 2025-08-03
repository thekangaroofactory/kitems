

#' Create item(s)
#'
#' @param values a named list of values, matching with the data.model
#' @param data.model a data.frame, defining the data model
#'
#' @return a data.frame of the new item
#' @export
#'
#' @details
#' Names in values must fit with the data.model - no attribute should
#' be missing (extra ones would be ignored).
#'
#' Case single item
#' Values should be submitted as a list of elements with length 1 or 0.
#' This means NULL, or length(0) values are accepted.
#'
#' Case multiple items
#' Values can be a data.frame or a list of elements with length > 1
#' The provided list must be convertible into a data.frame
#'
#' It is strongly advised to wrap calls to this function inside tryCatch
#' expressions as it will throw error rather than return a corrupted item.
#'
#' @examples
#' \dontrun{
#' item_create(values, data.model = mydatamodel)
#' }


# -- function definition
item_create <- function(values, data.model){

  # -- check parameter
  stopifnot("values argument must be a list or a data.frame" = is.list(values))

  # -- get colClasses from data.model
  colClasses <- dm_colClasses(data.model)

  # -- check parameter
  # abort if some attribute is missing from values
  if(any(!names(colClasses) %in% names(values)))
    stop("The item(s) cannot be created:", "\nmissing attribute(s) = ",
         paste(names(colClasses)[!names(colClasses) %in% names(values)], collapse = ", "))

  # -- helper function
  # turn single value into attribute
  helper_attribute <- function(key, value, colClass){

    # -- security check:
    # NULL will cause next test to fail
    if(is.null(value))
      value <- NA

    # -- security check:
    # 'Date' num(0) will cause next test to fail #428
    if(length(value) == 0)
      value <- NA

    # -- summary for debug
    catl("[item_create] attribute: key =", key, " / value =", value, "/ class =", colClass)

    # -- test: isTruthy(FALSE) >> FALSE
    # so need to skip for logicals // but include NA (is.logical(NA) >> TRUE)
    if(!is.logical(value) | is.na(value))

      if(!shiny::isTruthy(value)){

        catl("- Input not Truthy / Setting up default value", level = 2)
        value <- dm_default(data.model, key)}

    # -- test: match with target class
    # note: value might have several classes (case POSIX*)
    if(!colClass %in% class(value)){

      catl("- Warning! class", class(value), "does not fit with", colClass, "/ Coerce value to target class")
      value <- eval(call(CLASS_FUNCTIONS[[colClass]], value))
      catl("  >> output: class =", class(value), "/ value =", value)}

    # -- return
    c(key = value)

  }

  # -- helper function
  # turn data.frame of values into single item
  helper_item <- function(item_values, colClasses){

    # -- apply helper
    # on colClasses so as to ignore any additional entry in values
    item <- lapply(names(colClasses), function(x) helper_attribute(key = x,
                                                                   value = item_values[[x]],
                                                                   colClass = colClasses[[x]]))

    # -- rename & return as df
    names(item) <- names(colClasses)
    as.data.frame(item)

  }


  # ////////////////////////////////////////////////////////////////////////////
  # Case single item
  # - values should be submitted as a list of single elements with length 1 or 0

  # -- create & return single item
  if(!is.data.frame(values))
    if(all(lengths(values) <= 1))
      return(helper_item(item_values = values, colClasses))


  # ////////////////////////////////////////////////////////////////////////////
  # Case multiple items
  # - values could be a data.frame or list with multiple elements

  # -- turn list into a data.frame
  if(!is.data.frame(values))
    values <- tryCatch(
      as.data.frame(values),
      error = function(e) stop("The items cannot be created:\n", e$message))

  # -- apply helper
  # turn data.frame of values into a list of item(s)
  items <- if(!is.null(values))
    lapply(1:nrow(values), function(x) helper_item(item_values = values[x, ], colClasses))

  # -- bind into single data.frame & return
  # secure against NULL items, then return NULL
  if(!is.null(items))
    as.data.frame(dplyr::bind_rows(items))
  else NULL

}
