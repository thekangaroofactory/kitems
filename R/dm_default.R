

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

  catl("[dm_default] Default value, attribute =", name)

  # -- get defaults from data model
  default_val <- data.model[data.model$name == name, ]$default.val
  default_fun <- data.model[data.model$name == name, ]$default.fun
  default_arg <- data.model[data.model$name == name, ]$default.arg

  # -- P1: default function
  if(!is.na(default_fun)){

    catl("- strategy: default function =", default_fun, level = 2)

    # -- check arg
    args <- if(!is.na(default_arg))
      eval(parse(text = default_arg))
    else list()
    catl("- args: default arguments =", default_arg, level = 2)

    # -- wrapping next line into a tryCatch #235
    #value <- eval(do.call(ktools::getNsFunction(default_fun), args = list()))
    value <- tryCatch(eval(do.call(ktools::getNsFunction(default_fun), args = args)),

                      # -- if error
                      error = function(e) {

                        # -- print error
                        catl("[WARNING] There was an error when trying to apply the default function =", default_fun, debug = 1)
                        catl(e$message, debug = 1)

                        # -- return NA (default)
                        NA})

    }

  # -- P2: then default value
  else if(!is.na(default_val)){
    value <- default_val
    catl("- strategy: default value", level = 2)}

  # -- default: NA
  else{
    catl("- strategy: no default set, output = NA", level = 2)
    value <- NA}

  # -- return
  catl("- output: value =", value)
  value

}
