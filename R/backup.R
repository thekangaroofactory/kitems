

#' Backup Files
#'
#' @description
#' Backup data model & items files
#'
#' @param id the id used to create the data model.
#' @param path the path to the data model and items.
#' @param type the type of file to backup: "items" (default) or "dm".
#' @param max an integer to indicate how many backup files are allowed.
#'
#' @export
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' Backup file will be named as \emph{id_data_model_YYYY-MM-DD.rds} or \emph{id_items_YYYY-MM-DD.csv}
#' If same file already exists, it will be overwritten.
#'
#' If the number of backup files exceeds \code{max} then the oldest will be deleted.
#' Whenever \code{max = NULL} (default), it will be replaced by 1.
#'
#' @examples
#' \dontrun{
#' backup(id = "mydata", max = 2)
#' }

backup <- function(id, path = Sys.getenv("R_KITEMS_PATH"), type = "items", max = NULL){

  # -- check argument
  check_path(path)

  # -- source_url
  source_url <- ifelse(type == "dm", dm_url(id, path), items_url(id, path))
  if(!file.exists(source_url))
    stop(paste("Source file does not exist! file =", source_url))

  # -- check backup path
  backup_path <- file.path(path, "backup")
  if(!dir.exists(backup_path))
    dir.create(path = backup_path, showWarnings = FALSE)

  # -- target_url
  target_filename <- if(type == "dm")
    paste0(dm_name(id), "_", as.character(Sys.Date()), ".rds")
  else
    paste0(items_name(id), "_", as.character(Sys.Date()), ".csv")

  # -- create backup file
  backup_url <- file.path(backup_path, target_filename)
  file.copy(source_url, backup_url, overwrite = TRUE)
  catl("Backup has been created", backup_url)

  # -- check nb backup
  pattern <- ifelse(type == "dm", dm_name(id), items_name(id))
  backups <- list.files(path = backup_path, pattern = pattern, full.names = TRUE)
  n <- length(backups)

  # -- check arg max
  if(is.null(max))
    max <- 1

  # -- check nb of backups
  if(n > max){
    catl("Maximum backup files reached, cleaning old file(s)")
    unlink(head(backups, n = (n - max)))}

}
