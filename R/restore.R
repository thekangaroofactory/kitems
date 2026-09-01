

#' Restore Files
#'
#' @description
#' Restore config, data model or items files.
#'
#' @param type the type of file to restore (see details).
#' @param id the id for data.model & items.
#' @param path optional, the path to the data.
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' In case several backup files exist, the newest one will be restored.
#'
#' Values for `type` are "config" (the default), "items" or "dm".
#' When "config" is used, `id` is ignored.
#' "dm" is kept for compatibility purpose.
#'
#' @return a logical (see [file.copy()])
#'
#' @export
#' @importFrom utils tail
#'
#' @examples
#' \dontrun{
#' restore()
#' restore(type = "items", id = "foo")
#' }

restore <- function(type = c("config", "items", "dm"), id = NULL, path = Sys.getenv("R_KITEMS_PATH")){

  # -- check arguments
  check_path(path)
  type <- match.arg(type)

  # -- check backups
  pattern <- switch(type,
                    config = "_kitems",
                    items = name(id),
                    dm = name(id, what = "dm"))
  backup_path <- file.path(path, "backup")
  backup_url <- tail(list.files(path = backup_path,
                                pattern = pattern,
                                full.names = TRUE), n = 1)
  if(!length(backup_url))
    stop(paste("There is no backup available! pattern =", pattern))

  # -- source_url
  source_url <- switch(type,
                       config = name(what = "config", url = T),
                       items = name(id, url = T),,
                       dm = name(id, hat = "dm", url = T))

  # -- check source file
  if(file.exists(source_url)){
    suffix <- paste0("_obsolete_", strftime(Sys.time() , "%Y-%m-%dT%H-%M-%S"))
    extension <- switch(type, config = ".yml", dm = ".rds", items = ".csv")
    rename <- file.path(path, paste0(pattern, suffix, extension))
    file.rename(source_url, rename)
    message("Source file already exists, it has been renamed = ", rename)}

  # -- restore file
  file.copy(backup_url, source_url)

}
