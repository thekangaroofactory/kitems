

#' Default Value(s)
#'
#' @description
#' Compute default value(s).
#'
#' @param data.model the data.frame of the data model.
#'
#' @return A data.frame with default values.
#' @export
#'
#' @examples
#' dm <- data_model(colClasses = c(foo = "numeric"), default = 12)
#' dm_default(dm)

dm_default <- function(data.model){

  # -- check default(s)
  if(any(!is.na(data.model$default))){

    catl("Compute default(s)")

    # -- helper function to deal with the vectorized evaluation
    helper <- function(x) {

      # -- parse text to expression
      y <- rlang::parse_expr(x)

      # -- check if evaluation is required (call)
      # otherwise return unchanged input
      if(rlang::is_call(y))

        tryCatch({
          catl("- Call requires an evaluation:", x, level = 2)

          # -- raw value
          value <- rlang::eval_tidy(y, data = NULL)

          # -- convert to character
          # ISO-8601 to keep timezone for POSIXct
          value <- if("POSIXct" %in% class(value))
            format(value, "%FT%H:%M:%S%z")
          else as.character(value)},

          error = function(e) {
            warning("Error when trying to evaluate default =", y, "\n", e$message)
            NA})

      else x}

    # --
    data.model <- data.model |>
      dplyr::mutate(default = unlist(lapply(.data$default, helper)))

  }

  # -- drop columns & return
  data.model |>
    dplyr::select(!c("class.arg", "display", "skip", "refresh", "sort.rank", "sort.desc"))

}
