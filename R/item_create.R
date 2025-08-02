

#' Create new item
#'
#' @param values a named list of values, matching with the data.model
#' @param data.model a data.frame, defining the data model
#'
#' @return a data.frame of the new item
#' @export
#'
#' @details
#' Names in values must fit with the data.model - no attribute should
#' be missing (extra ones would be ignored). When used in the context
#' of trigger creation workflow, it means that even skipped attributes
#' need to have an entry in the list.
#'
#' @examples
#' \dontrun{
#' item_create(values, data.model = mydatamodel)
#' }


# -- function definition
item_create <- function(values, data.model){

  # -- get colClasses from data.model
  colClasses <- dm_colClasses(data.model)

  # -- check parameter
  # abort if some attribute is missing from values
  if(any(!names(colClasses) %in% names(values))){
    warning("The item cannot be created:", "\nmissing attribute(s) = ",
            paste(names(colClasses)[!names(colClasses) %in% names(values)], collapse = ", "))
    return()}


  # -- helper function (takes single values)
  helper <- function(key, value, colClass){

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


  # -- apply helper
  # on colClasses so as to ignore any additional entry in values
  item <- lapply(names(colClasses), function(x) helper(key = x,
                                                   value = values[[x]],
                                                   colClass = colClasses[[x]]))

  # -- rename & return as df
  names(item) <- names(colClasses)
  item <- as.data.frame(item)

}
