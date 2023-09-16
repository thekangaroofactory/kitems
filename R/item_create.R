

#' Create a new item
#'
#' @param values a list of values, most likely output values coming from UI inputs
#' @param colClasses a named vector of classes, defining the data model
#' @param default.val a named list, providing default values for given attributes
#' @param default.fun a named list, providing default functions to compute the default values for given attributes
#' @param coerce_functions a named list, providing the as function for each supported type
#'
#'
#' @return a data.frame of the new item, coerced to match with colClasses
#'
#' @examples


# -- function definition
item_create <- function(values, colClasses, default.val, default.fun, coerce){

  # note: evolution = use of do.call("fun", args) with a named list as args
  # to support use of default.fun with arguments insteaf of just ()


  # ***********************************************************
  # *** this trick to solve the use of :: for package functions
  # >> should be exported to ktools package for reuse
  getfun <- function(x) {
    if(length(grep("::", x)) > 0) {
      parts <- strsplit(x, "::")[[1]]
      getExportedValue(parts[1], parts[2])
    } else {
      x
    }
  }
  # ***********************************************************


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

        # -- P1: default function
        if(!is.null(default.fun)){
          cat("- strategy: applying default function \n")
          value <- eval(do.call(getfun(default.fun), args = list()))}

        # -- P2: then default value
        else if(!is.null(default.val)){
          cat("- strategy: applying default value \n")
          value <- default.val}

        # -- default: NA
        else{
          cat("- strategy: setting as NA \n")
          value <- NA}

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
                                                   values[[x]],
                                                   colClasses[[x]],
                                                   if(x %in% names(default.val)) default.val[[x]] else NULL,
                                                   if(x %in% names(default.fun)) default.fun[[x]] else NULL,
                                                   coerce))

  # -- rename & return as df
  names(item) <- names(values)
  item <- as.data.frame(item)

}
