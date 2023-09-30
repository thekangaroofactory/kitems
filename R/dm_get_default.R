

#' Title
#'
#' @param data.model
#' @param name
#'
#' @return
#' @export
#'
#' @examples

dm_get_default <- function(data.model, name){


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


  # -- get defaults from data model
  default_fun <- data.model[data.model$name == name, ]$default.fun
  default_val <- data.model[data.model$name == name, ]$default.val

  # -- P1: default function
  if(!is.na(default_fun)){
    value <- eval(do.call(getfun(default_fun), args = list()))
    cat("- strategy: applying default function, output =", value, "\n")}

  # -- P2: then default value
  else if(!is.na(default_val)){
    value <- default_val
    cat("- strategy: applying default value, output =", value, "\n")}

  # -- default: NA
  else{
    cat("- strategy: setting as NA \n")
    value <- NA}

  # -- return
  value

}
