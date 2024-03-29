

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
  default.val <- dm_default_val(data.model)
  default.fun <- dm_default_fun(data.model)

  # -- helper function (takes single values)
  helper <- function(key, value, class, default.val, default.fun){

    # -- security check: NULL will cause next test to fail
    if(is.null(value))
      value <- NA

    # -- coerce value
    cat("Helper function: \n")
    cat("  - key =", key, "\n")
    cat("  - value =", value, "\n")
    cat("  - class =", class, "\n")
    cat("  - default.val =", default.val, "\n")
    cat("  - default.fun =", default.fun, "\n")

    # -- test: isTruthy(FALSE) >> FALSE so need to skip for logicals // but include NA (is.logical(NA) >> TRUE)
    if(!is.logical(value) | is.na(value))

      if(!shiny::isTruthy(value)){

        cat("Input not Truthy / Setting up default value \n")
        value <- dm_get_default(data.model, key)

      } else
        cat("Input is Truthy, nothing to do \n")

    # -- coerce value
    cat("Coerce value to given class \n")
    value <- eval(call(CLASS_FUNCTIONS[[class]], value))
    cat("Output:", class(value), value, "\n")

    # -- return
    c(key = value)

  }


  # -- apply helper values & rename output
  item <- lapply(names(values), function(x) helper(key = x,
                                                   value = values[[x]],
                                                   class = colClasses[[x]],
                                                   default.val = if(x %in% names(default.val)) default.val[[x]] else NULL,
                                                   default.fun = if(x %in% names(default.fun)) default.fun[[x]] else NULL))

  # -- rename & return as df
  names(item) <- names(values)
  item <- as.data.frame(item)

}
