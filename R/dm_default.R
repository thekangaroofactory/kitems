

#' Compute default value for an attribute
#'
#' @param data.model a data.frame containing the data model
#' @param name a character string with the attribute name
#'
#' @return the default value or computed output of the default function
#' @export
#'
#' @examples
#' \dontrun{
#' value <- dm_default(data.model = mydatamodel, name = "date")
#' }


dm_default <- function(data.model, name){

  cat("[dm_default] Get default for attribute:", name, "\n")

  # -- get defaults from data model
  default_val <- data.model[data.model$name == name, ]$default.val
  default_fun <- data.model[data.model$name == name, ]$default.fun
  default_arg <- data.model[data.model$name == name, ]$default.arg

  # -- P1: default function
  if(!is.na(default_fun)){

    cat("- strategy: applying default function =", default_fun, "\n")

    # -- check arg
    args <- if(!is.na(default_arg))
      eval(parse(text = default_arg))
    else list()
    cat("- args: default arguments =", default_arg, "\n")

    # -- wrapping next line into a tryCatch #235
    #value <- eval(do.call(ktools::getNsFunction(default_fun), args = list()))
    value <- tryCatch(eval(do.call(ktools::getNsFunction(default_fun), args = args)),

                      # -- if error
                      error = function(e) {

                        # -- print error
                        cat("[WARNING] There was an error when trying to apply the default function =", default_fun, "\n")
                        print(e)

                        # -- return NA (default)
                        NA})

    }

  # -- P2: then default value
  else if(!is.na(default_val)){
    value <- default_val
    cat("- strategy: applying default value \n")}

  # -- default: NA
  else{
    cat("- strategy: no default set, output = NA \n")
    value <- NA}

  # -- return
  cat("- output: value =", value, "\n")
  value

}
