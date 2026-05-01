

#' Default Value(s)
#'
#' @description
#' Compute default value(s).
#'
#' @param data.model the data.frame of the data model.
#'
#' @return A data.frame with a 'default' column.
#' @export
#'
#' @examples
#' dm <- data_model(colClasses = c(foo = "numeric"), default.val = 12)
#' dm_default(dm)

dm_default <- function(data.model){

  # -- default function
  if(any(!is.na(data.model$default.fun))){

    catl("- strategy: default function =", x$default.fun, level = 2)

    # maybe a function to deal with the evaluation
    foo_eval <- function(x) {

      unlist(as.character(lapply(rlang::parse_exprs(x), function(y) {

        tryCatch({

          rlang::eval_tidy(y, data = NULL)},

          # -- failed (return NA)
          error = function(e) {
            warning("Error when trying to apply default function =", y, "\n", e$message)
            NA}) })))

    }

    data.model <- data.model |>
      mutate(default.val = replace_when(default.val, !is.na(default.fun) ~ foo_eval(default.fun)))

  }

  # -- drop columns & return
  data.model |>
    select(!c(class.arg, default.fun, display, sort.rank, sort.desc)) |>
    rename(default = default.val)

}
