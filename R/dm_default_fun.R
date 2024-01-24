

#' Extract default function from data model
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a named vector of the attribute default functions
#' @export
#'
#' @examples
#' \dontrun{
#' dm_default_fun(data.model = mydatamodel)
#' }


dm_default_fun <- function(data.model){

  # -- Slice data model
  dm <- data.model[!is.na(data.model$default.fun), c("name", "default.fun")]

  # -- Extract default_fun
  default_fun <- dm$default.fun
  names(default_fun) <- dm$name

  # -- return
  default_fun

}
