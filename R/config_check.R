

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
#' @export
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
    rc <- append(rc, list(code = 1, type = "note", message = "Extra element(s) found at root level"))

  # version
  if(!identical(config$version, as.character(utils::packageVersion("kitems"))))
    rc <- append(rc, list(code = 2, type = "warning", message = paste("Config requires a migration to version", as.character(utils::packageVersion("kitems")))))

  # no items
  if(!length(config$items))
    rc <- append(rc, list(code = 3, type = "note", message = "No item found in the project"))


  # ////////////////////////////////////////////////////////////////////////////
  # Item

  # item
  item_helper <- function(n, items){

    item <- items[[n]]
    rv <- list()

    # id
    if(is.null(item$id))
      rv <- append(rv, list(code = 4, type = "error", message = paste("Item", n, "has no id"), item = n))
    else if(!is.character(item$id) || !length(item$id))
      rv <- append(rv, list(code = 5, type = "error", message = paste("Item", n, "has invalid id"), item = n))

    # source
    if(is.null(item$source))
      rv <- append(rv, list(code = 6, type = "error", message = paste("Item", n, "has no source"), item = n))
    else if(is.null(item$source$type))
      rv <- append(rv, list(code = 7, type = "error", message = paste("Item", n, "has no source type"), item = n))

    # file
    if(item$source$type == "file")
      if(!file.exists(file.path(item$source$path, item$source$filename)))
        rv <- append(rv, list(code = 8, type = "error", message = paste("Item", n, "has no item file"), item = n))

    # data.model
    if(is.null(item$data.model))
      rv <- append(rv, list(code = 9, type = "note", message = paste("Item", n, "has no data model"), item = n))

    else {

      # attributes
      if(is.null(item$data.model$attributes))
        rv <- append(rv, list(code = 10, type = "note", message = paste("Item", n, "has no attribute"), item = n))

      else {

        if(!"id" %in% sapply(item$data.model$attributes, function(x) x$name))
          rv <- append(rv, list(code = 11, type = "error", message = "Item has no id attribute", item = n))


        # loop over attributes
        rv <- append(rv, unlist(lapply(1:length(item$data.model$attributes),
                                       attribute_helper, item$data.model$attributes), recursive = FALSE))

        # skip
        x <- item$data.model$skip %in% sapply(item$data.model$attributes, function(x) x$name)
        if(any(!x))
          rv <- append(rv, list(code = 12, type = "warning",
                           message = paste("Item", n, "has unknown skipped attribute(s)"), item = n, unknown = item$data.model$skip[!x]))

        # refresh
        x <- item$data.model$refresh %in% item$data.model$skip
        if(any(!x))
          rv <- append(rv, list(code = 13, type = "warning",
                           message = paste("Item", n, "has refreshed attribute(s) that are not skipped"),
                           item = n, unknown = item$data.model$refresh[!x]))

        # hide
        x <- item$data.model$hide %in% sapply(item$data.model$attributes, function(x) x$name)
        if(any(!x))
          rv <- append(rv, list(code = 14, type = "warning",
                           message = paste("Item", n, "has unknown hidden attribute(s)"), item = n, unknown = item$data.model$hide[!x]))

      }

    }

    # return
    rv

  }

  # attribute
  attribute_helper <- function(n, attributes){

    attribute <- attributes[[n]]
    rx <- list()

    if(!is.list(attribute))
      rx <- append(rx, list(code = 15, type = "error", message = "Attribute should be a list", attribute = n))

    if(!all(c("name", "type") %in% names(attribute)))
      rx <- append(rx, list(code = 16, type = "error", message = "Attribute has missing name or type", attribute = n))

    if(!is.character(attribute$name) || !length(attribute$name))
      rx <- append(rx, list(code = 17, type = "error", message = "Attribute name is invalid", attribute = n))

    if(!attribute$type %in% OBJECT_CLASS)
      rx <- append(rx, list(code = 17, type = "error", message = "Attribute type is invalid", attribute = n))

    rx

  }

  # loop over length & return
  # so position is captured
  append(rc, lapply(1:length(config$items), item_helper, config$items))

}
