

#' Create a new item
#'
#' @param values a list of values, most likely output values coming from UI inputs
#' @param data.model a data.frame, defining the data model
#' @param coerce a named list, providing the as function for each supported type
#'
#'
#' @return a data.frame of the new item, coerced to match with colClasses
#'
#' @examples


# -- function definition
item_create <- function(values, data.model, coerce){

  # -- init params from data.model
  colClasses <- dm_colClasses(data.model)
  default.val <- dm_default_val(data.model)
  default.fun <- dm_default_fun(data.model)

  # -- helper function (takes single values)
  helper <- function(key, value, class, default.val, default.fun, coerce){

    # -- coerce value
    cat("Helper function: \n")
    cat("  - key =", key, "\n")
    cat("  - value =", value, "\n")
    cat("  - class =", class, "\n")
    cat("  - default.val =", default.val, "\n")
    cat("  - default.fun =", default.fun, "\n")

    # -- test: isTruthy(FALSE) >> FALSE so need to skip for logicals // but include NA (is.logical(NA) >> TRUE)
    if(!is.logical(value) | is.na(NA))

      if(!shiny::isTruthy(value)){

        cat("Input not Truthy / Setting up default value \n")
        value <- dm_get_default(data.model, key)

        # # -- P1: default function
        # if(!is.null(default.fun)){
        #   cat("- strategy: applying default function \n")
        #   value <- eval(do.call(getfun(default.fun), args = list()))}
        #
        # # -- P2: then default value
        # else if(!is.null(default.val)){
        #   cat("- strategy: applying default value \n")
        #   value <- default.val}
        #
        # # -- default: NA
        # else{
        #   cat("- strategy: setting as NA \n")
        #   value <- NA}

      } else
        cat("Input is Truthy, nothing to do \n")

    # -- coerce value
    cat("Coerce value to given class \n")
    value <- eval(call(coerce[[class]], value))
    cat("Output: \n")
    str(value)

    # -- return
    c(key = value)

  }


  # -- apply helper values & rename output
  item <- lapply(names(values), function(x) helper(key = x,
                                                   value = values[[x]],
                                                   class = colClasses[[x]],
                                                   default.val = if(x %in% names(default.val)) default.val[[x]] else NULL,
                                                   default.fun = if(x %in% names(default.fun)) default.fun[[x]] else NULL,
                                                   coerce = coerce))

  # -- rename & return as df
  names(item) <- names(values)
  item <- as.data.frame(item)

}
