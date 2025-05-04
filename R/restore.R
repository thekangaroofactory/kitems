

#' Restore Data Model & Items Files
#'
#' @param id the kitems id used to create the data model
#' @param path the path to the data model
#' @param type the type of file to backup. \code{items} (default) or \code{dm}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' restore(id = "mydata", path = "path/to/mydata", type = "items")
#' restore(id = "mydata", path = "path/to/mydata", type = "dm")
#' }

restore <- function(id, path, type = "items"){

  # -- check path
  if(!dir.exists(path))
    stop(paste("Path does not exist! path =", path))

  # -- check backup path
  backup_path <- file.path(path, "backup")
  if(!dir.exists(backup_path))
    stop(paste("Backup path does not exist! path =", backup_path))

  # -- check backups
  pattern <- ifelse(type == "dm", dm_name(id), items_name(id))
  backups <- list.files(path = backup_path, pattern = pattern, full.names = TRUE)
  if(length(backups) == 0)
    stop(paste("There is no backup available! pattern =", pattern))

  # -- get backup_url
  backup_url <- tail(backups, n = 1)

  # -- get source_url
  source_url <- if(type == "dm")
    file.path(path, paste0(dm_name(id), ".rds"))
  else
    file.path(path, paste0(items_name(id), ".csv"))

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
