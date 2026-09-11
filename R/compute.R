

#' Attribute Values
#'
#' @description
#' Compute attribute values with data-masking support
#'
#' @param x a character string of the expression to evaluate
#' @param data a data.frame to use for tidy evaluation of `x`
#'
#' @returns a vector of values
#' @export
#'
#' @examples
#' compute(x = "suggest(1, 2)")
#' compute(x = "suggest(min(value))", data = data.frame(value = c(12, 10)))

compute <- function(x, data = NULL){

  # -- parse input string to expression
  expr <- rlang::parse_expr(x)

  # -- drop call to suggest / limit / lifecycle
  # basically get the arguments of the call
  expr <- rlang::call_args(expr)

  # -- check if evaluation is required & return
  if(!rlang::is_atomic(unlist(expr)))

    unlist(lapply(expr, function(x)
      if(!rlang::is_atomic(x))
        tryCatch(
          rlang::eval_tidy(x, data = data),
          error = function(e) {
            warning("Attribute constraint could not be evaluated: ", e$message, call. = F)
            return(NULL)})
      else x))

  else unlist(expr)

}
