

#' Backup Data Model & Items Files
#'
#' @param id the kitems id used to create the data model
#' @param path the path to the data model
#' @param type the type of file to backup. \code{items} (default) or \code{dm}
#' @param max an integer to indicate how many backup files are allowed
#'
#' @export
#'
#' @details
#' Backup file will be named as \emph{id_data_model_YYYY-MM-DD.rds}
#' If same file already exists, it will be overwritten.
#'
#' If the number of backup files exceeds \code{max} then the oldest will be deleted.
#' Whenever \code{max = NULL} (default), it will be replaced by 1
#'
#' @examples
#' backup(id = "mydata", path = "path/to/my/data", max = 2)


backup <- function(id, path, type = "items", max = NULL){

  # -- check path
  if(!dir.exists(path))
    stop(paste("Path does not exist! path =", path))

  # -- get source_url
  source_url <- if(type == "dm")
    file.path(path, paste0(dm_name(id), ".rds"))
  else
    file.path(path, paste0(items_name(id), ".csv"))

  # -- get target_url
  target_url <- if(type == "dm")
    paste0(dm_name(id), "_", as.character(Sys.Date()), ".rds")
  else
    paste0(items_name(id), "_", as.character(Sys.Date()), ".csv")

  # -- check source file
  if(!file.exists(source_url))
    stop(paste("Source file does not exist! file =", source_url))

  # -- check backup path
  backup_path <- file.path(path, "backup")
  if(!dir.exists(backup_path))
    dir.create(path = backup_path, showWarnings = FALSE)

  # -- create backup file
  backup_url <- file.path(backup_path, target_url)
  file.copy(source_url, backup_url, overwrite = TRUE)
  cat("Backup has been created", backup_url, "\n")

  # -- check nb backup
  pattern <- ifelse(type == "dm", dm_name(id), items_name(id))
  backups <- list.files(path = backup_path, pattern = pattern, full.names = TRUE)
  n <- length(backups)

  # -- check arg max
  if(is.null(max))
    max <- 1

  # -- check nb of backups
  if(n > max){
    cat("Maximum backup files reached, cleaning old file(s)")
    unlink(head(backups, n = (n - max)))}

}
