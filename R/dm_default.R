

#' Default Value(s)
#'
#' @description
#' Compute the default value(s).
#'
#' @param data.model a data.frame containing the data model.
#' @param name a character string with the attribute name.
#' @param n an integer (default 1) to use when a vector is expected
#' for default function case (otherwise it will be ignored).
#'
#' @details
#' Whenever a default function is set for an attribute of the data.model,
#' it is possible to generate a vector of default values instead of a single
#' default value by using n parameter. This is useful when the function
#' generates single values (time or unique id for example)
#'
#' @return A vector of length `n`.
#' @export
#'
#' @examples
#' dm <- data_model(colClasses = c(foo = "numeric"), default.val = 12)
#' dm_default(dm, "foo")

dm_default <- function(data.model, name, n = 1){

  # -- get attribute's defaults
  catl("Default value, attribute =", name)
  x <- data.model[data.model$name == name, c("default.val", "default.fun")]


  # ////////////////////////////////////////////////////////////////////////////

  # -- P1: default function
  if(!is.na(x$default.fun)){

    catl("- strategy: default function =", x$default.fun, level = 2)

    # -- wrapping into a tryCatch #235
    value <- tryCatch({

      # -- Support multiple values #489
      # replicate calls default_fun n times (simplify = F to get a list)
      # do.call convert list into vector AND keep class!
      # do.call("c",
      #         replicate(n,
      #                   eval(do.call(ktools::getNsFunction(default_fun), args = args)),
      #                   simplify = F))

      # -- parse string & evaluate expression #642
      # tidy evaluation is used to allow data-masking (use of items column names)
      expr <- rlang::parse_expr(x$default.fun)
      if(!rlang::is_call(expr))
        stop("Default function should be a call")
      if(n > 1)
        replicate(n, rlang::eval_tidy(expr, data = NULL))
      else
        rlang::eval_tidy(expr, data = NULL)},

      # -- failed (return NA)
      error = function(e) {
        warning("Error when trying to apply default function =", x$default.fun, "\n", e$message)
        NA})}


  # ////////////////////////////////////////////////////////////////////////////

  # -- P2: then default value
  else if(!is.na(x$default.val)){
    value <- x$default.val
    catl("- strategy: default value", level = 2)}


  # ////////////////////////////////////////////////////////////////////////////

  # -- default: NA
  else{
    catl("- strategy: no default set", level = 2)
    value <- NA}


  # ////////////////////////////////////////////////////////////////////////////

  # -- return
  catl("- output: value =", as.character(value))
  value

}
