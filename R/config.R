

#' Create YAML Configuration File
#'
#' @param project a character string to indicate the name of the project
#'
#' @returns a list
#' @export
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
#' @export
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
#' @export
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
#' @param item the name of the item
#'
#' @returns a vector
#' @export
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
#' @export
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
#' @export
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


#' Item Connector
#'
#' @param config the YAML config
#' @param item the name of the item
#'
#' @returns a list
#' @export
#'
#' @examples
#' yaml <- config_create("test") |>
#'   config_item_append(config_item_create(id = "foo", path = "/temp"))
#'
#' config_item_connector(yaml, "foo")

config_item_connector <- function(config, item){

  x <- config_extract(config, item)$source
  x$path <- file.path(x$path, item)
  x$filename = paste0(items_name(item), ".csv")

  x

}


#' Item colClasses
#'
#' @param config the yaml config
#' @param item the name of the item
#'
#' @returns a named vector
#' @export
#'
#' @examples
#' # create a config
#' yaml <- config_create("test") |>
#'   config_item_append(config_item_create(id = "foo", path = "/temp")) |>
#'   config_attribute_append(item = "foo",
#'                           attribute = config_attribute_create(name = "id",
#'                                                               type = "numeric"))
#'
#' # get item colClasses
#' config_item_colclasses(yaml, "foo")

config_item_colclasses <- function(config, item){

  sapply(config_extract(config, item)$data.model$attributes,
         function(x) rlang::set_names(x$type, x$name))

}


#' Create Item Config
#'
#' @description
#' Helper function to create the config section for an item.
#'
#' @param id a character string to set the name of the item group
#' @param description an optional description for the item
#' @param path an optional character string where to find the data
#'
#' @details
#' When `path` is not provided, the R_KITEMS_PATH environment variable
#' will be used.
#'
#' @returns a list
#' @export
#'
#' @examples
#' config_item_create(id = "foo", path = "./")

config_item_create <- function(id, description = NULL, path = Sys.getenv("R_KITEMS_PATH")){

  # -- secure
  check_path(path)
  if(!is.character(id)){
    warning("Argument id must be a character string.")
    return(NULL)}

  # -- init
  config <- list(id = id,
                 source = list(type = "file",
                               path = file.path(path, id),
                               filename = basename(items_url(id))))

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
#' @export
#'
#' @examples
#' config_item_append(config_create("prj"),
#'                    config_item_create(id = "a", path = "."))

config_item_append <- function(config, ...){

  # -- secure against NULL
  args <- Filter(Negate(is.null), list(...))

  # -- append
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
#' @export
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
#' @export
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


#' Sort Items
#'
#' @param config the yaml config
#' @param item the name of the item to drop
#' @param sort a character string
#'
#' @details
#' `sort` will be used to order the items.
#' Comma should be used between attribute names.
#' Wrap attribute name with desc() to indicate descending order.
#'
#' @returns the new config
#' @export
#'
#' @examples
#' \dontrun{
#' # define sorting
#' config_item_sort(config, item, sort = "date, value")
#' config_item_sort(config, item, sort = "desc(date), value")
#'
#' # reset sorting
#' config_item_sort(config, item, sort = NULL)
#' }

config_item_sort <- function(config, item, sort = NULL){

  # -- get item index
  item_idx <- config_item_position(config, item)

  # -- update sort
  config$items[[item_idx]]$data.model$sort <- if(is.null(sort) || sort == "") NULL else sort

  # -- return
  config

}


#' Create Attribute
#'
#' @param name the name of the attribute
#' @param type the type of the attribute
#' @param class.arg optional argument to sent to the as.* conversion function
#' @param values a character string to set the rules for values
#' @param default a character string to define the defaults
#'
#' @returns a list
#' @export
#'
#' @examples
#' \dontrun{
#' config_attribute_create(name = "att_1", type = "integer")
#' }

config_attribute_create <- function(name, type, class.arg = NULL, values = NULL, default = NULL){

  # -- secure
  if(!type %in% OBJECT_CLASS){
    warning("Argument", crayon::blue("type"), "must match supported types.")
    return(NULL)}
  if(!is.character(name)){
    warning("Argument", crayon::blue("name"), "must be a character string.")
    return(NULL)}

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
#' @param refresh a logical (default = FALSE) if the attribute should be refreshed
#'
#' @returns the new config
#' @export
#'
#' @examples
#' \dontrun{
#' config_attribute_append(config, item = foo,
#'                         attribute = config_attribute_create(name = "bar", type "numeric"))
#' }

config_attribute_append <- function(config, item, attribute, hide = FALSE, skip = FALSE, refresh = FALSE){

  # -- get item
  item_idx <- config_item_position(config, item)
  if(identical(item_idx, integer(0))){
    warning("Item ", crayon::blue(item), " is not found in config.")
    return(config)}

  # -- get last attribute position
  attribute_idx <- length(config_attributes(config, item)) + 1

  # -- append attribute at position
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
#' @param refresh a logical (default = FALSE) if the attribute should be refreshed
#'
#' @returns the new config
#' @export
#'
#' @examples
#' \dontrun{
#' config_attribute_update(config, item = foo,
#'                         attribute = config_attribute_create(name = "bar", type "numeric"))
#' }

config_attribute_update <- function(config, item, attribute, hide = FALSE, skip = FALSE, refresh = FALSE){

  # -- secure against forbidden actions
  if(attribute$name == "id"){
    warning("Updating the ", crayon::blue("id"), " attribute is forbidden.", call. = FALSE)
    return(config)}

  # -- get item & attribute positions
  item_idx <- config_item_position(config, item)
  attribute_idx <- config_attribute_position(config, item, attribute$name)

  # -- secure against forbidden actions
  if(config$items[[item_idx]]$data.model$attributes[[attribute_idx]]$type != attribute$type){
    warning("Updating the attribute ", crayon::blue("type"), " is forbidden.", call. = FALSE)
    return(config)}

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
#' @export
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
#' @export
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
