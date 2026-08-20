

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

  which(config_attributes(config_extract(config, item)) == attribute)

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

  # -- extract item
  if(!is.null(item))
    config <- config$items[[config_item_position(config, item)]]

  # -- extract attribute
  if(!is.null(attribute))
    config <- config$data.model$attributes[[which(config_attributes(config) == attribute)]]

  # -- return
  config

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
#'
#' @returns a list
#'
#' @examples
#' config_attribute_create(name = "att_1", type = "integer")

config_attribute_create <- function(name, type){

  lits(name = name,
       type = type)

}


#' Append Attribute
#'
#' @param config the yaml config
#' @param item the name of the target item
#' @param attribute the attribute config
#'
#' @returns the new config
#'
#' @examples
#' \dontrun{
#' config_attribute_append(config, item = foo,
#'                         attribute = config_attribute_create(name = "bar", type "numeric"))
#' }

config_attribute_append <- function(config, item, attribute){

  # -- get item position in config$items
  item_idx <- config_item_position(config, item)

  # -- need position where to insert / append
  attribute_idx <- length(config_attributes(config_extract(config, item))) + 1
  config$items[[item_idx]]$data.model$attributes[[attribute_idx]] <- attribute

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
  att_order <- append(att_list[!att_list %in% attribute], attribute, after = target_idx)

  # -- reorder attributes
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

  # -- drop attribute
  config$items[[item_idx]]$data.model$attributes <- config$items[[item_idx]]$data.model$attributes[-idx_to_drop]

  # -- return
  config

}
