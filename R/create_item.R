

#' Create a new item
#'
#' @param values a list of values, most likely output values coming from UI inputs
#' @param colClasses a named vector of classes, defining the data model
#' @param default.val a named list, providing default values for given attributes
#' @param default.fun a named list, providing default functions to compute the default values for given
#' attributes
#'
#' @return a data.frame of the new item, coerced to match with colClasses
#'
#' @examples


# -- function definition
create_item <- function(values, colClasses, default.val, default.fun){

  cat("Create item: \n")

  # -- fill in missing inputs with defaults
  # ----------------------------------------------------------------------------

  cat("- Computing default values... \n")

  # -- helper
  helper <- function(name){

    # -- init (if no default value or fun has been submitted)
    value <- NA

    # -- check default values
    if(name %in% names(default.val))
      value <- default.val[[name]]

    # -- check default functions
    if(name %in% names(default.fun))
      value <- default.fun[[name]]()

    # -- name & return
    names(value) <- name
    cat("--", name, "=", value, "\n")
    value

  }

  # -- apply helper on NULL values
  new_values <- lapply(names(values[sapply(values, is.null)]), function(x) helper(x))

  # -- replace NULL with computed values
  values[names(unlist(new_values))] <- unlist(new_values)

  # -- Coerce input values to match with colClasses
  # ----------------------------------------------------------------------------

  cat("- Coerce values to colClasses \n")

  # -- helper
  helper <- function(value, class){
    cat("value =", value, "\n")
    cat("class =", class, "\n")
    CLASS_FUNCTIONS[[class]](value)}

  # -- apply helper on list of values & rename output
  item <- lapply(names(values), function(x) helper(values[[x]], colClasses[[x]]))
  names(item) <- names(values)


  # -- return a df
  # ----------------------------------------------------------------------------
  item <- as.data.frame(item)

}
