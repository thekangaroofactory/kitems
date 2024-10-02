

#' Migrate data model
#'
#' @param data.model a data.frame of the data model
#' @param missing_col a named list of the missing columns (most probably a subset of the target colClasses)
#'
#' @return the migrated data.model
#' @export
#'
#' @examples
#' \dontrun{
#' dm_migrate(data.model, missing_col = list(default.arg = "character"))
#' }

dm_migrate <- function(data.model, name){

  cat("[dm_migrate] Data model migration, missing columns =", name, "\n")

  # -- add missing columns
  # fill with defaults
  suppressWarnings(data.model[name] <- DATA_MODEL_DEFAULTS[name])

  # -- return
  data.model

}
