

#' Create YAML Configuration File
#'
#' @param project a character string to indicate the name of the project
#'
#' @returns a list
#'
#' @examples
#' config_create(project = "my_project")

config_create <- function(project){

  # -- return
  list(
    version = as.character(packageVersion("kitems")),
    project = project)

}


#' Config Items
#'
#' @description
#' Get the item names (id) in a YAML config.
#'
#' @param config a yaml config
#'
#' @returns a vector
#'
#' @examples
#' config_items(list(items = list(config_item_create(id = "foo", path = "./"),
#'                                config_item_create(id = "bar", path = "./"))))

config_items <- function(config){

  sapply(config$items, function(x) x$id)

}


#' Item Position
#'
#' @param config a yaml config
#' @param item the name of the item to locate
#'
#' @returns an integer
#'
#' @examples
#' \dontrun{
#' config_item_position(config, item = "foo")
#' }

config_item_position <- function(config, item){

  which(config_items(config) == item)

}


#' Config Attributes
#'
#' @description
#' Get the attribute names in an item YAML config section.
#'
#' @param config a yaml config section for an item
#'
#' @returns a vector
#'
#' @examples
#' \dontrun{
#' config_attributes(config)
#' }

config_attributes <- function(config, item){

  sapply(config_extract(config, item)$data.model$attributes, function(x) x$name)

}


#' Attribute Position
#'
#' @param config a yaml config
#' @param item the target item
#' @param attribute the name of the attribute to locate
#'
#' @returns an integer
#'
#' @examples
#' \dontrun{
#' config_attribute_position(config, item = "foo", attribute = "bar")
#' }

config_attribute_position <- function(config, item, attribute){

  which(config_attributes(config, item) == attribute)

}


#' Extract Config
#'
#' @description
#' Extract the section for a specific item or attribute.
#'
#' @param config the yaml configuration
#' @param item optional, the name (id) of the item
#' @param attribute optional, the name of the attribute
#'
#' @details
#' When `item` is NULL, it is expected that `config` contains the yaml
#' section for an item.
#'
#' If both `item` and `attribute` are left NULL, the function will
#' return the input.
#'
#' @returns a list (the yaml section for the attribute)
#'
#' @examples
#' \dontrun{
#' config_extract(config, item = "foo")
#' config_extract(config, item = "foo", attribute = "bar")
#' }

config_extract <- function(config, item = NULL, attribute = NULL){

  # -- init
  x <- config

  # -- extract item
  if(!is.null(item))
    x <- config$items[[config_item_position(config, item)]]

  # -- extract attribute
  if(!is.null(attribute))
    x <- x$data.model$attributes[[config_attribute_position(config, item, attribute)]]

  # -- return
  x

}


#' Create Item Config
#'
#' @description
#' Helper function to create the config section for an item.
#'
#' @param id a character string to set the name of the item group
#' @param path a character string where to find the data
#'
#' @returns a list
#'
#' @examples
#' config_item_create(id = "foo", path = "./")

config_item_create <- function(id, description = NULL, path){

  # -- init
  config <- list(id = id,
                 source = list(type = "file",
                               path = path))

  # -- append description
  if(!is.null(description))
    config <- append(config, list(description = description), 1L)

  # -- return
  config

}


#' Append Item
#'
#' @param config the yaml config
#' @param ... item(s) to append
#'
#' @returns the new config
#'
#' @examples
#' config_item_append(config_create("prj"),
#'                    config_item_create(id = "a", path = "."))

config_item_append <- function(config, ...){

  config$items <- c(config$items, list(...))
  config

}


#' Move Item
#'
#' @param config the yaml config
#' @param item the name of the item to move
#' @param where a list(position = c("before", "after"), item = "foo")
#'
#' @returns the new config
#'
#' @examples
#' \dontrun{
#' config_item_move(config, item = "bar", where = list(position = "before", item = "foo"))
#' }

config_item_move <- function(config, item, where){

  # -- get item list
  item_list <- config_items(config)

  # -- get target index
  target_idx <- which(item_list == where$item)
  if(where$position == "before")
    target_idx <- target_idx - 1

  # -- reorder item indexes
  item_order <- append(item_list[!item_list %in% item], item, after = target_idx)

  # -- do reorder
  config$items <- config$items[match(item_order, item_list)]

  # -- return
  config

}


#' Drop Item
#'
#' @param config the yaml config
#' @param item the name of the item to drop
#'
#' @returns the new config
#'
#' @examples
#' \dontrun{
#' config_item_drop(config, item = "foo")
#' }

config_item_drop <- function(config, item){

  # -- drop item
  config$items <- config$items[-config_item_position(config, item)]

  # -- return
  config

}


#' Create Attribute
#'
#' @param name the name of the attribute
#' @param type the type of the attribute
#' @param class.arg optional argument to sent to the as.* conversion function
#'
#' @returns a list
#'
#' @examples
#' config_attribute_create(name = "att_1", type = "integer")

config_attribute_create <- function(name, type, class.arg = NULL, values = NULL, default = NULL){

  # -- init
  config <- list(name = name,
                 type = type)

  # -- class.arg
  if(!is.null(class.arg))
    config <- c(config, list(class.arg = class.arg))

  # -- values
  if(!is.null(values) && rlang::call_name(rlang::parse_expr(values)) != "any")
    config <- c(config, list(values = values))

  # -- default
  if(!is.null(default))
    config <- c(config, list(default = default))

  # -- return
  config

}


#' Append Attribute
#'
#' @param config the yaml config
#' @param item the name of the target item
#' @param attribute the attribute config
#' @param hide a logical (default = FALSE) if the attribute should be hidden
#' @param skip a logical (default = FALSE) if the attribute should be skipped
#'
#' @returns the new config
#'
#' @examples
#' \dontrun{
#' config_attribute_append(config, item = foo,
#'                         attribute = config_attribute_create(name = "bar", type "numeric"))
#' }

config_attribute_append <- function(config, item, attribute, hide = FALSE, skip = FALSE, refresh = FALSE){

  # -- get item & (last) attribute positions
  item_idx <- config_item_position(config, item)
  attribute_idx <- length(config_attributes(config, item)) + 1

  # -- append attribute
  config$items[[item_idx]]$data.model$attributes[[attribute_idx]] <- attribute

  # -- update hide / skip & refresh
  if(hide)
    config$items[[item_idx]]$data.model$hide <- c(config$items[[item_idx]]$data.model$hide, attribute$name)
  if(skip)
    config$items[[item_idx]]$data.model$skip <- c(config$items[[item_idx]]$data.model$skip, attribute$name)
  if(refresh)
    config$items[[item_idx]]$data.model$refresh <- c(config$items[[item_idx]]$data.model$refresh, attribute$name)

  # -- return
  config

}


#' Update Attribute
#'
#' @param config the yaml config
#' @param item the name of the target item
#' @param attribute the attribute config
#' @param hide a logical (default = FALSE) if the attribute should be hidden
#' @param skip a logical (default = FALSE) if the attribute should be skipped
#'
#' @returns the new config
#'
#' @examples
#' \dontrun{
#' config_attribute_update(config, item = foo,
#'                         attribute = config_attribute_create(name = "bar", type "numeric"))
#' }

config_attribute_update <- function(config, item, attribute, hide = FALSE, skip = FALSE, refresh = FALSE){

  # -- get item & attribute positions
  item_idx <- config_item_position(config, item)
  attribute_idx <- config_attribute_position(config, item, attribute$name)

  # -- update attribute
  config$items[[item_idx]]$data.model$attributes[[attribute_idx]] <- attribute

  # -- update hide
  config$items[[item_idx]]$data.model$hide <- if(hide)
    unique(c(config$items[[item_idx]]$data.model$hide, attribute$name))
  else
    config$items[[item_idx]]$data.model$hide[!config$items[[item_idx]]$data.model$hide %in% attribute$name]
  # update skip
  config$items[[item_idx]]$data.model$skip <- if(skip)
    unique(c(config$items[[item_idx]]$data.model$skip, attribute$name))
  else
    config$items[[item_idx]]$data.model$skip[!config$items[[item_idx]]$data.model$skip %in% attribute$name]
  # update refresh
  config$items[[item_idx]]$data.model$refresh <- if(refresh)
    unique(c(config$items[[item_idx]]$data.model$refresh, attribute$name))
  else
    config$items[[item_idx]]$data.model$refresh[!config$items[[item_idx]]$data.model$refresh %in% attribute$name]

  # -- return
  config

}


#' Move Attribute
#'
#' @param config the yaml config
#' @param item the name of the target item
#' @param attribute the name of the attribute to move
#' @param where a list(position = c("before", "after"), attribute = "foo")
#'
#' @returns the new config
#'
#' @examples
#' \dontrun{
#' config_attribute_move(config, "item_1", "att_1", list(position = "after", attribute = "att_2"))
#' }

config_attribute_move <- function(config, item, attribute, where){

  # -- get target index
  target_idx <-  config_attribute_position(config, item, where$attribute)
  if(where$position == "before")
    target_idx <- target_idx - 1

  # -- reorder attribute indexes
  att_list <- config_attributes(config, item)
  att_order <- append(att_list[!att_list %in% attribute], attribute, after = target_idx)

  # -- reorder attributes
  item_idx <- config_item_position(config, item)
  config$items[[item_idx]]$data.model$attributes <- config$items[[item_idx]]$data.model$attributes[match(att_order, att_list)]

  # -- return
  config

}


#' Drop Attribute
#'
#' @param config the yaml config
#' @param item the target item
#' @param attribute the name of the attribute to drop
#'
#' @returns the new yaml config
#'
#' @examples
#' \dontrun{
#' config_attribute_drop(config, item = "foo", attribute = "att_1")
#' }

config_attribute_drop <- function(config, item, attribute){

  # -- get idx to drop
  idx_to_drop <- config_attribute_position(config, item, attribute)
  item_idx <- config_item_position(config, item)

  # -- drop attribute
  config$items[[item_idx]]$data.model$attributes <- config$items[[item_idx]]$data.model$attributes[-idx_to_drop]

  # -- update hide, skip & refresh
  config$items[[item_idx]]$data.model$hide <- config$items[[item_idx]]$data.model$hide[!config$items[[item_idx]]$data.model$hide %in% attribute]
  config$items[[item_idx]]$data.model$skip <- config$items[[item_idx]]$data.model$skip[!config$items[[item_idx]]$data.model$skip %in% attribute]
  config$items[[item_idx]]$data.model$refresh <- config$items[[item_idx]]$data.model$refresh[!config$items[[item_idx]]$data.model$refresh %in% attribute]

  # -- return
  config

}
