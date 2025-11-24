

#' Default Value(s)
#'
#' @description
#' Compute the default value(s).
#'
#' @param data.model a data.frame containing the data model.
#' @param name a character string with the attribute name.
#' @param n an integer (default 1) to use when a vector is expected
#' for default function case.
#'
#' @details
#' Whenever a default function is set for an attribute of the data.model,
#' it is possible to generate a vector of default values instead of a single
#' default value by using n parameter. This is usefull when the function
#' generates single values (time or unique id for example)
#'
#' @return A vector of length `n`.
#' @export
#'
#' @examples
#' \dontrun{
#' value <- dm_default(data.model = mydatamodel, name = "date")
#' }

dm_default <- function(data.model, name, n = 1){

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

    # -- wrapping into a tryCatch #235
    value <- tryCatch(

      # -- Support multiple values #489
      # replicate calls default_fun n times (simplify = F to get a list)
      # do.call convert list into vector AND keep class!
      do.call("c",
              replicate(n,
                        eval(do.call(ktools::getNsFunction(default_fun), args = args)),
                        simplify = F)),

      # -- failed
      error = function(e) {

        # -- print error
        warning("Error when trying to apply default function =", default_fun, "\n", e$message, debug = 1)

        # -- return NA (as default)
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
  catl("- output: value =", as.character(value))
  value

}
