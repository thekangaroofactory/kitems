

#' Check Config
#'
#' @description
#' Check YAML config structure & content
#'
#' @param config a config list
#'
#' @details
#' The function will return a list of problems or an empty list.
#' Each problem has a type (note, warning or error) and a message.
#' Errors are most likely to prevent the package from working properly.
#' Warnings may affect the behavior.
#' Notes are here for information but should not affect the behavior.
#'
#' @returns a list
#'
#' @examples
#' \dontrun{
#' config_check(config)
#' }

config_check <- function(config){

  # -- init
  rc <- list()


  # ////////////////////////////////////////////////////////////////////////////
  # Structure

  # type
  if(!is.list(config))
    stop("The config object must be a list.", call. = FALSE)

  # 1st level entries
  if(any(!names(config) %in% c("version", "project", "items")))
    rc[[length(rc)+1]] <- list(code = 1, type = "note", message = "Extra element(s) found at root level")

  # version
  if(!identical(config$version, as.character(utils::packageVersion("kitems"))))
    rc[[length(rc)+1]] <- list(code = 2, type = "warning", message = paste("Config requires a migration to version", as.character(utils::packageVersion("kitems"))))

  # no items
  # if so exit function here!
  if(!length(config$items)){
    rc[[length(rc)+1]] <- list(code = 3, type = "note", message = "No item found in the project")
    return(rc)}


  # ////////////////////////////////////////////////////////////////////////////
  # Item

  # item
  item_helper <- function(n, items){

    item <- items[[n]]
    rv <- list()

    # id
    if(is.null(item$id))
      rv[[length(rv)+1]] <- list(code = 4, type = "error", message = paste("Item", n, "has no id"), item = n)
    else if(!is.character(item$id) || !length(item$id))
      rv[[length(rv)+1]] <- list(code = 5, type = "error", message = paste("Item", n, "has invalid id"), item = n)

    # source
    if(is.null(item$source))
      rv[[length(rv)+1]] <- list(code = 6, type = "error", message = paste("Item", n, "has no source"), item = n)
    else {

      # type
      if(is.null(item$source$type))
        rv[[length(rv)+1]] <- list(code = 7, type = "error", message = paste("Item", n, "has no source type"), item = n)
      else
        # file
        if(item$source$type == "file")
          if(!file.exists(file.path(item$source$path, item$source$filename)))
            rv[[length(rv)+1]] <- list(code = 8, type = "error", message = paste("Item", n, "has no item file"), item = n)}

    # data.model
    if(is.null(item$data.model))
      rv[[length(rv)+1]] <- list(code = 9, type = "note", message = paste("Item", n, "has no data model"), item = n)

    else {

      # attributes
      if(is.null(item$data.model$attributes))
        rv[[length(rv)+1]] <- list(code = 10, type = "note", message = paste("Item", n, "has no attribute"), item = n)

      else {

        if(!"id" %in% sapply(item$data.model$attributes, function(x) x$name))
          rv[[length(rv)+1]] <- list(code = 11, type = "error", message = "Item has no id attribute", item = n)

        # loop over attributes
        ra <- unlist(lapply(1:length(item$data.model$attributes),
                                            attribute_helper, item$data.model$attributes), recursive = FALSE)
        if(length(ra))
          rv[[length(rv)+1]] <- unlist(ra, recursive = F)

        # skip
        x <- item$data.model$skip %in% sapply(item$data.model$attributes, function(x) x$name)
        if(any(!x))
          rv[[length(rv)+1]] <- list(code = 12, type = "warning",
                                     message = paste("Item", n, "has unknown skipped attribute(s)"), item = n, unknown = item$data.model$skip[!x])

        # refresh
        x <- item$data.model$refresh %in% item$data.model$skip
        if(any(!x))
          rv[[length(rv)+1]] <- list(code = 13, type = "warning",
                                     message = paste("Item", n, "has refreshed attribute(s) that are not skipped"),
                                     item = n, unknown = item$data.model$refresh[!x])

        # hide
        x <- item$data.model$hide %in% sapply(item$data.model$attributes, function(x) x$name)
        if(any(!x))
          rv[[length(rv)+1]] <- list(code = 14, type = "warning",
                                     message = paste("Item", n, "has unknown hidden attribute(s)"), item = n, unknown = item$data.model$hide[!x])

      }

    }

    # return
    rv

  }

  # attribute
  attribute_helper <- function(n, attributes){

    attribute <- attributes[[n]]
    rx <- list()

    if(!"name" %in% names(attribute))
      rx[[length(rx)+1]] <- list(code = 15, type = "error", message = "Attribute has missing name", attribute = n)
    else
      if(!is.character(attribute$name) || !length(attribute$name))
        rx[[length(rx)+1]] <- list(code = 16, type = "error", message = "Attribute name is invalid", attribute = n)

    if(!"type" %in% names(attribute))
      rx[[length(rx)+1]] <- list(code = 17, type = "error", message = "Attribute has missing type", attribute = n)
    else
      if(!attribute$type %in% OBJECT_CLASS)
        rx[[length(rx)+1]] <- list(code = 18, type = "error", message = "Attribute type is invalid", attribute = n)

    # return
    rx

  }

  # loop over length & return
  # so position is captured
  ri <- unlist(lapply(1:length(config$items), item_helper, config$items), recursive = F)

  # return
  if(length(ri))
    append(rc, ri)
  else
    rc

}
