

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

  # -- secure against multiple values
  if(length(project) > 1)
    project <- project[[1]]

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
#' @returns a vector or list() if no item is found.
#' @export
#'
#' @examples
#' config_items(list(items = list(config_item_create(id = "foo", path = "./"),
#'                                config_item_create(id = "bar", path = "./"))))

config_items <- function(config){

  sapply(config$items, function(x) x$id)

}


#' Item Exists
#'
#' @description
#' Check whether or not an item exists in the config.
#'
#' @param config the config list
#' @param item the name (id) of the item(s) to check
#'
#' @returns a logical
#' @export
#'
#' @examples
#' # build config
#' config <- design(project = "test",
#' item = "foo")
#'
#' # check
#' config |> is_item("foo")
#' config |> is_item("bar)

is_item <- function(config, item){

  item %in% config_items(config)

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

  x <- which(config_items(config) == item)
  if(!length(x)){
    warning("Item ", crayon::blue(item), " does not exist!", call. = F)
    NA
  } else x

}


#' Config Attributes
#'
#' @description
#' Get the attribute names in an item YAML config section.
#'
#' @param config a yaml config section for an item.
#' @param item the name of the item.
#'
#' @returns a vector or list() if not found.
#' @export
#'
#' @examples
#' \dontrun{
#' config_attributes(config)
#' }

config_attributes <- function(config, item){

  # no need to check
  # will produce list() if item is missing
  sapply(config$items[[config_item_position(config, item)]]$data.model$attributes,
    function(x) x$name)

}


#' Attribute Exists
#'
#' @description
#' Checks whether or not an attribute exists within an item.
#'
#' @param config the config list
#' @param item the name (id) of the item
#' @param attribute a character vector holding the name of the attribute(s) to check
#'
#' @returns a logical
#' @export
#'
#' @examples
#' # build config (id attribute is mandatory)
#' config <- design(project = "test",
#' item = "foo")
#'
#' # check
#' config |> is_attribute(item = "foo", attribute = "id")
#' config |> is_attribute(item = "foo", attribute = "dummy")

is_attribute <- function(config, item, attribute){

  attribute %in% config_attributes(config, item)

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

  if(!length(idx <- which(config_attributes(config, item) == attribute))){
    warning("Attribute ", crayon::blue(attribute), " does not exist in item ", crayon::blue(item), "!", call. = F)
    NA
  } else idx

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

  # -- extract item
  if(!is.null(item))
    x <- config$items[[config_item_position(config, item)]]

  # -- extract attribute
  if(!is.null(attribute))
    x <- x$data.model$attributes[[config_attribute_position(config, item, attribute)]]

  # -- return
  if(exists("x")) x else NULL

}


#' Item Connector
#'
#' @param config the YAML config
#' @param item the name of the item
#'
#' @returns a list or NULL if the item is not found.
#' @export
#'
#' @examples
#' yaml <- config_create("test") |>
#'   config_item_append(config_item_create(id = "foo", path = "/temp"))
#'
#' config_item_connector(yaml, "foo")

config_item_connector <- function(config, item){

  # -- secure against missing item
  if(!is.null(x <- config$items[[config_item_position(config, item)]]$source)){
    x$path <- file.path(x$path, item)
    x$filename = paste0(items_name(item), ".csv")}

  # -- return
  x

}


#' Item colClasses
#'
#' @param config the yaml config
#' @param item the name of the item
#'
#' @returns a named vector or list() if the item is not found.
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

  sapply(config$items[[config_item_position(config, item)]]$data.model$attributes,
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
                               filename = basename(items_url(id))),
                 data.model = list(attributes = list(list(name = "id",
                                                          type = "numeric",
                                                          default = "ktools::uuid()")),
                                   skip = "id"))

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

  # -- secure against duplicated items
  candidates <- config_items(list(items = args))
  rejected <- duplicated(candidates) | candidates %in% config_items(config)
  if(any(rejected)){
    warning("Some duplicated items (", crayon::blue(paste(candidates[rejected], collapse = ", ")), ") are rejected.", call. = F)
    args <- args[!rejected]}

  # -- append
  config$items <- c(config$items, args)
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

  # -- do reorder
  config$items <- config$items[match(append(item_list[!item_list %in% item],
                                            item, after = target_idx),
                                     item_list)]

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

  # -- get item index & drop
  # secure against missing item
  if(is.na(idx <- config_item_position(config, item)))
    return(config)
  else
    config$items <- config$items[-idx]

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
  if(is.na(idx <- config_item_position(config, item)))
    return(config)

  # -- update sort
  config$items[[idx]]$data.model$sort <- if(is.null(sort) || sort == "") NULL else sort

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
#' @param ... one or several attribute config(s)
#'
#' @returns the new config
#' @export
#'
#' @examples
#' \dontrun{
#' config_attribute_append(config, item = foo,
#'                         attribute = config_attribute_create(name = "bar", type "numeric"))
#' }

config_attribute_append <- function(config, item, ...){

  # -- item position
  if(is.na(item_idx <- config_item_position(config, item)))
    return(config)

  # -- loop over ...
  for(attribute in list(...)){

    # -- secure from duplicated attribute names
    reserved <- config_attributes(config, item)
    if(attribute$name %in% reserved){
      warning("Attribute ", crayon::blue(attribute$name), " already exists in item ", crayon::blue(item), ".")
      return(config)}

    # -- append attribute at position
    config$items[[item_idx]]$data.model$attributes[[length(reserved) + 1]] <- attribute

  }

  # -- return
  config

}


#' Update Attribute
#'
#' @param config the yaml config
#' @param item the name of the target item
#' @param attribute the attribute config
#'
#' @returns the new config
#' @export
#'
#' @examples
#' \dontrun{
#' config_attribute_update(config, item = foo,
#'                         attribute = config_attribute_create(name = "bar", type "numeric"))
#' }

config_attribute_update <- function(config, item, attribute){

  # -- secure against forbidden actions
  if(attribute$name == "id"){
    warning("Updating the ", crayon::blue("id"), " attribute is forbidden.", call. = FALSE)
    return(config)}

  # -- attribute & item positions
  # attribute will check both exist
  if(is.na(attribute_idx <- config_attribute_position(config, item, attribute$name)))
     return(config)
  item_idx <- config_item_position(config, item)

  # -- secure against forbidden actions
  if(config$items[[item_idx]]$data.model$attributes[[attribute_idx]]$type != attribute$type){
    warning("Updating the attribute ", crayon::blue("type"), " is forbidden.", call. = FALSE)
    return(config)}

  # -- update attribute
  config$items[[item_idx]]$data.model$attributes[[attribute_idx]] <- attribute

  # -- return
  config

}


#' Attribute Behaviors
#'
#' @description
#' Function to set/unset the skip, refresh & hide attribute behaviors.
#'
#' @param config the config list
#' @param item the targeted item id
#' @param behavior which behavior to manipulate ("skip", "refresh" or "hide")
#' @param ... the name of the attribute(s) to skip
#' @param set a logical (default = TRUE) if the behavior should be set or unset
#'
#' @returns
#' @export
#'
#' @examples
#' \dontrun{
#' config_attribute_behavior(config, item = "foo", behavior = "skip", "id")
#' config_attribute_behavior(config, item = "foo", behavior = "hide", "id", set = FALSE)
#' }

config_attribute_behavior <- function(config, item, behavior, ..., set = TRUE){

  # -- secure against missing item / attribute(s)
  attributes <- unlist(list(...)[is_attribute(config, item, list(...))])
  if(!length(attributes))
    return(config)

  # -- refresh
  if(behavior == "refresh"){
    # -- secure from trying to refresh id
    if("id" %in% attributes){
      warning("It is forbidden to refresh the ", crayon::blue("id"), " attribute!", call. = F)
      return(config)}
    # -- secure from trying to refresh an attribute that is not skipped
    attributes <- attributes[attributes %in% config_item_behavior(config, item)]}

  # -- get item index
  # already checked above
  item_idx <- config_item_position(config, item)

  # -- alter config
  # secure against character(0) because of [[]]
  old <- config$items[[item_idx]]$data.model[[behavior]]
  new <- if(set)
    unique(c(old, attributes))
  else
    old[!old %in% attributes]
  config$items[[item_idx]]$data.model[[behavior]] <- if(length(new)) new else NULL

  # -- return
  config

}


#' Item Behaviors
#'
#' @description
#' Get the attribute names for a specific behavior.
#'
#' @param config the config list
#' @param item the name (id) of the item
#' @param behavior the name of the behavior (default = "skip")
#'
#' @details
#' Behaviors:
#' - "skip" the default
#' - "refresh"
#' - "hide"
#'
#' @returns a character vector or NULL
#' @export
#'
#' @examples
#' \dontrun{
#' config_item_behavior(config, item = "foo")
#' }

config_item_behavior <- function(config, item, behavior = c("skip", "refresh", "hide")){

  # -- check arg
  behavior <- match.arg(behavior)

  # -- secure against missing item
  if(is.na(idx <- config_item_position(config, item)))
    NULL
  else
    config$items[[idx]]$data.model[[behavior]]

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

  # -- idx to drop
  # secure against missing item / attribute
  if(is.na(idx_to_drop <- config_attribute_position(config, item, attribute))){
    return(config)}

  # -- item index
  item_idx <- config_item_position(config, item)

  # -- drop attribute
  config$items[[item_idx]]$data.model$attributes <- config$items[[item_idx]]$data.model$attributes[-idx_to_drop]

  # -- update hide, skip & refresh
  config <- config |>
    config_attribute_behavior(item, behavior = "hide", set = FALSE) |>
    config_attribute_behavior(item, behavior = "skip", set = FALSE) |>
    config_attribute_behavior(item, behavior = "refresh", set = FALSE)

  # -- return
  config

}
