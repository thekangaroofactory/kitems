

#' Create a new item
#'
#' @param values a list of values, most likely output values coming from UI inputs
#' @param data.model a data.frame, defining the data model
#'
#' @return a data.frame of the new item, coerced to match with colClasses
#' @export
#'
#' @examples
#' \dontrun{
#' item_create(values, data.model = mydatamodel)
#' }


# -- function definition
item_create <- function(values, data.model){

  # -- init params from data.model
  colClasses <- dm_colClasses(data.model)

  # -- helper function (takes single values)
  helper <- function(key, value, colClass){

    # -- security check:
    # NULL will cause next test to fail
    if(is.null(value))
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


  # -- apply helper values & rename output
  item <- lapply(names(values), function(x) helper(key = x,
                                                   value = values[[x]],
                                                   colClass = colClasses[[x]]))

  # -- rename & return as df
  names(item) <- names(values)
  item <- as.data.frame(item)

}
