

#' Extract default values from data model
#'
#' @param data.model a data.frame containing the data model
#'
#' @return a named vector of the attribute default values
#' @export
#'
#' @examples
#' \dontrun{
#' dm_default_val(data.model = mydatamodel)
#' }


dm_default_val <- function(data.model){

  # -- Slice data model
  dm <- data.model[!is.na(data.model$default.val), c("name", "default.val")]

  # -- Extract default_val
  default_val <- dm$default.val
  names(default_val) <- dm$name

  # -- return
  default_val

}
