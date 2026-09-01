

#' Kitems Names
#'
#' @description
#' Helper function to homogenize names across the package.
#'
#' @param id the name (id) of the item group.
#' @param what the targeted object (item, dm or config).
#' @param file a logical if file extension should be added.
#' @param url a logical if the url should be returned.
#' @param backup a logical if a timestamp should be added.
#'
#' @details
#' "dm" is kept for backward compatibility reasons (backup & restore old
#' data.model files before migration to YAML config).
#'
#' When `url` is `TRUE`, then `file` is considered `TRUE` as well.
#' When `backup` is `TRUE`, then `file` is considered `TRUE` as well.
#'
#' Note that from v0.8.0 url for the config is build from the
#' `R_KITEMS_PATH` environment variable and url for the item groups
#' is contained in the YAML config.
#'
#' @returns a character string
#' @export
#'
#' @examples
#' # item name
#' name("foo")

name <- function(id = NULL, what = c("item", "dm", "config"), file = FALSE, url = FALSE, backup = FALSE){

  # -- check
  what <- match.arg(what)

  # -- name
  nm <- switch (what,
                dm = paste0(id, "_data_model"),
                config = "_kitems",
                paste0(id, "_items"))

  # -- data.model backup
  if(backup)
    nm <- paste(nm, format(Sys.time(), "%Y%m%d_T%H%M%S"), sep = "_")

  # -- filename
  if(file || url || backup)
    nm <- switch (what,
                  dm = paste0(nm, ".rds"),
                  config = paste0(nm, ".yml"),
                  paste0(nm, ".csv"))

  # -- url
  if(url)
    nm <- file.path(ifelse(what != "config", file.path(Sys.getenv("R_KITEMS_PATH"), id), Sys.getenv("R_KITEMS_PATH")), nm)

  # -- return
  nm

}
