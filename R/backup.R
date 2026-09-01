

#' Backup Files
#'
#' @description
#' Backup config, data model or items files
#'
#' @param type the type of file to backup (see details).
#' @param id the id of the item or data model.
#' @param max an integer (default = 1) to indicate how many backup files are allowed.
#' @param path optional, the path to the data.
#'
#' @details
#' Type of files:
#' - "config" (the default)
#' - "items"
#' - "dm"
#'
#' "dm" is kept to enable data.model backup before migration to the YAML config.
#'
#' `id` will be ignored if `type = "config"`
#'
#' @export
#' @importFrom utils head
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' Backup file will be named as \emph{_kitems_YYYY-MM-DD.yml},
#' \emph{id_data_model_YYYY-MM-DD.rds} or \emph{id_items_YYYY-MM-DD.csv}
#' If same file already exists, it will be overwritten.
#'
#' @examples
#' \dontrun{
#' # backup config
#' backup()
#' }

backup <- function(type = c("config", "items", "dm"),
                   id = NULL, max = 1, path = Sys.getenv("R_KITEMS_PATH")){

  # -- check arguments
  check_path(path)
  type <- match.arg(type)

  # -- define & check source
  source_url <- switch(type,
                       config = name(what = "config", url = T),
                       items = name(id, url = T),
                       dm = name(id, what = "dm", url = T))
  if(!file.exists(source_url))
    stop(paste("Source file does not exist! file =", source_url))

  # -- check backup path
  backup_path <- file.path(path, "backup")
  if(!dir.exists(backup_path))
    dir.create(path = backup_path)

  # -- target_url
  target_filename <- switch(type,
                            config = paste0("_kitems_", as.character(Sys.Date()), ".yml"),
                            items = name(id, file = T, backup = T),
                            dm = name(id, what = "dm", file = T, backup = T))

  # -- create backup file
  backup_url <- file.path(backup_path, target_filename)
  file.copy(source_url, backup_url, overwrite = TRUE)
  message("Backup has been created: ", backup_url)

  # -- check nb backup
  pattern <- switch(type,
                    config = "_kitems.yml",
                    items = name(id),
                    dm = name(id, what = "dm"))
  backups <- list.files(path = backup_path, pattern = pattern, full.names = TRUE)
  n <- length(backups)

  # -- check nb of backups
  if(n > max){
    message("Maximum backup files reached, cleaning older file(s).")
    unlink(head(backups, n = (n - max)))}

}
