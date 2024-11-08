

#' Migrate data model
#'
#' @param data.model a data.frame of the data model
#' @param name a named list of the missing columns (most probably a subset of the target colClasses)
#'
#' @return the migrated data.model
#' @export
#'
#' @examples
#' \dontrun{
#' dm_migrate(data.model, name = list(default.arg = "character"))
#' }

dm_migrate <- function(data.model, name){

  catl("[dm_migrate] Data model migration, missing columns =", name)

  # -- add missing columns
  # fill with defaults
  tryCatch(data.model[name] <- DATA_MODEL_DEFAULTS[name],
           error = function(e) print(e$message),
           warning = function(w) print(w$message))

  # -- return
  data.model

}
