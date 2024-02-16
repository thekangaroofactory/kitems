

#' Default value for an attribute
#'
#' @param data.model a data.frame containing the data model
#' @param name a character string with the attribute name
#'
#' @return the default value or computed output of the default function
#' @export
#'
#' @examples
#' \dontrun{
#' value <- dm_get_default(data.model = mydatamodel, name = "date")
#' }


dm_get_default <- function(data.model, name){

  cat("[dm_get_default] Get default value for attribute:", name, "\n")

  # -- get defaults from data model
  default_fun <- data.model[data.model$name == name, ]$default.fun
  default_val <- data.model[data.model$name == name, ]$default.val

  # -- P1: default function
  if(!is.na(default_fun)){

    # -- wrapping next line into a tryCatch #235
    #value <- eval(do.call(ktools::getNsFunction(default_fun), args = list()))
    value <- tryCatch(eval(do.call(ktools::getNsFunction(default_fun), args = list())),

                      error = function(e) {

                        # -- print error
                        cat("[WARNING] There was an error when trying to apply the default function =", default_fun, "\n")
                        print(e)

                        # -- return NA (default)
                        NA})

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
