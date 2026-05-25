

#' Restore Files
#'
#' @description
#' Restores the data model & items files.
#'
#' @param id the id used to create the data model.
#' @param path the path to the data model and items.
#' @param type the type of file to backup. \code{items} (default) or \code{dm}.
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' @export
#' @importFrom utils tail
#'
#' @examples
#' \dontrun{
#' restore(id = "mydata", type = "items")
#' restore(id = "mydata", type = "dm")
#' }

restore <- function(id, path = Sys.getenv("R_KITEMS_PATH"), type = c("items", "dm")){

  # -- check arguments
  check_path(path)
  type <- match.arg(type)

  # -- check backup path
  backup_path <- file.path(path, "backup")
  if(!dir.exists(backup_path))
    stop(paste("Backup path does not exist! path =", backup_path))

  # -- check backups
  pattern <- ifelse(type == "dm", dm_name(id), items_name(id))
  backups <- list.files(path = backup_path, pattern = pattern, full.names = TRUE)
  if(length(backups) == 0)
    stop(paste("There is no backup available! pattern =", pattern))

  # -- backup_url
  backup_url <- tail(backups, n = 1)

  # -- source_url
  source_url <- ifelse(type == "dm", dm_url(id, path), items_url(id, path))

  # -- check source file
  if(file.exists(source_url)){
    base <- ifelse(type == "dm", dm_name(id), items_name(id))
    suffix <- paste0("_obsolete_", strftime(Sys.time() , "%Y-%m-%dT%H-%M-%S"))
    extension <- ifelse(type == "dm", ".rds", ".csv")
    rename <- paste0(base, suffix, extension)
    rename <- file.path(path, rename)
    file.rename(source_url, rename)
    catl("Source file already exists, it has been renamed =", rename, debug = 1)}

  # -- create backup file
  # setting overwrite by security
  res <- file.copy(backup_url, source_url)
  catl("File has been restored", source_url)

}
