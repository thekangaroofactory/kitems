

#' Check Integrity
#'
#' @description
#' Wrapper function to either check the YAML config or items integrity.
#'
#' @param ... the object(s) to check (see details)
#'
#' @details
#' The function is smart enough to detect what is passed to `...`.
#' To check the items, it is necessary to also pass the corresponding
#' id in the config (see examples).
#'
#' @returns a list
#' @export
#'
#' @examples
#' \dontrun{
#' # check config (list)
#' config <- design(project = "test")
#' check(config)
#'
#' # check items (data.frame)
#' check(items, config, id = "foo")
#' }

check <- function(...){

  # -- check
  if(!length(arg <- list(...)))
    stop("At least one argument should be supplied to ...")

  # -- detect config
  if(length(idx_c <- which(sapply(arg, class) == "list")))
    rc <- config_check(arg[[idx_c]])

  # -- detect items
  if(!exists("rc") || !length(rc)){
    if(length(x <- which(sapply(arg, class) == "data.frame")))
      if(!is.null(arg$id))
        if(!is_item(arg[[idx_c]], arg$id)){
          stop("Item ", arg$id, "is not in the YAML config!")
        } else
          rc <- item_check(arg[[x]], arg[[idx_c]], arg$id)}

  # -- return
  if(exists("rc")) rc else list()

}
