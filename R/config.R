

#' Create YAML Configuration File
#'
#' @param project a character string to indicate the name of the project
#'
#' @returns a list
#' @noRd
#'
#' @examples
#' c_create(project = "my_project")

c_create <- function(project){

  # -- secure against multiple values
  if(length(project) > 1)
    project <- project[[1]]

  # -- return
  list(
    version = as.character(utils::packageVersion("kitems")),
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
#' @noRd
#'
#' @examples
#' c_items(list(items = list(ci_create(id = "foo", path = "./"),
#'                                ci_create(id = "bar", path = "./"))))

c_items <- function(config){

  sapply(config$items, function(x) x$id)

}


#' Item Exists
#'
#' @description
#' Check whether or not an item exists in the config.
#'
#' @param config the config list
#' @param item the name (id) of the item group
#'
#' @returns a logical
#' @noRd
#'
#' @examples
#' # build config
#' config <- design(project = "test", item = "foo")
#'
#' # check
#' config |> is_item("foo")
#' config |> is_item("bar")

is_item <- function(config, item){

  item %in% c_items(config)

}


#' Item Position
#'
#' @param config a yaml config
#' @param item the name (id) of the item group
#'
#' @returns an integer
#' @noRd
#'
#' @examples
#' \dontrun{
#' ci_position(config, item = "foo")
#' }

ci_position <- function(config, item){

  x <- which(c_items(config) == item)
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
#' @param item the name (id) of the item group
#'
#' @returns a vector or list() if not found.
#' @noRd
#'
#' @examples
#' \dontrun{
#' c_attributes(config)
#' }

c_attributes <- function(config, item){

  # no need to check
  # will produce list() if item is missing
  sapply(config$items[[ci_position(config, item)]]$data.model$attributes,
    function(x) x$name)

}


#' Attribute Exists
#'
#' @description
#' Checks whether or not an attribute exists within an item.
#'
#' @param config the config list
#' @param item the name (id) of the item group
#' @param attribute a character vector holding the name of the attribute(s) to check
#'
#' @returns a logical
#' @noRd
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

  attribute %in% c_attributes(config, item)

}


#' Attribute Position
#'
#' @param config a yaml config
#' @param item the name (id) of the item group
#' @param attribute the name of the attribute to locate
#'
#' @returns an integer
#' @noRd
#'
#' @examples
#' \dontrun{
#' ca_position(config, item = "foo", attribute = "bar")
#' }

ca_position <- function(config, item, attribute){

  if(!length(idx <- which(c_attributes(config, item) == attribute))){
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
#' @param item optional, the name (id) of the item group
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
#' @noRd
#'
#' @examples
#' \dontrun{
#' c_extract(config, item = "foo")
#' c_extract(config, item = "foo", attribute = "bar")
#' }

c_extract <- function(config, item = NULL, attribute = NULL){

  # -- extract item
  if(!is.null(item))
    x <- config$items[[ci_position(config, item)]]

  # -- extract attribute
  if(!is.null(attribute))
    x <- x$data.model$attributes[[ca_position(config, item, attribute)]]

  # -- return
  if(exists("x")) x else NULL

}


#' Item Connector
#'
#' @param config the YAML config
#' @param item the name (id) of the item group
#'
#' @returns a list or NULL if the item is not found.
#' @noRd
#'
#' @examples
#' yaml <- c_create("test") |>
#'   ci_append(ci_create(id = "foo", path = "/temp"))
#'
#' ci_connector(yaml, "foo")

ci_connector <- function(config, item){

  # -- secure against missing item
  if(!is.null(x <- config$items[[ci_position(config, item)]]$source)){
    x$path <- dirname(name(item, url = T))
    x$filename = name(item, file = T)}

  # -- return
  x

}


#' Item colClasses
#'
#' @param config the yaml config
#' @param item the name (id) of the item group
#'
#' @returns a named vector or list() if the item is not found.
#' @noRd
#'
#' @examples
#' # create a config
#' yaml <- c_create("test") |>
#'   ci_append(ci_create(id = "foo", path = "/temp")) |>
#'   ca_append(item = "foo",
#'                           attribute = ca_create(name = "id",
#'                                                               type = "numeric"))
#'
#' # get item colClasses
#' ci_classes(yaml, "foo")

ci_classes <- function(config, item){

  sapply(config$items[[ci_position(config, item)]]$data.model$attributes,
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
#' @noRd
#'
#' @examples
#' ci_create(id = "foo", path = "./")

ci_create <- function(id, description = NULL, path = Sys.getenv("R_KITEMS_PATH")){

  # -- secure
  # path is not checked as it is tested before
  # otherwise examples will fail.
  if(!is.character(id)){
    warning("Argument id must be a character string.")
    return(NULL)}

  # -- init
  config <- list(id = id,
                 source = list(type = "file",
                               path = dirname(name(id, url = T)),
                               filename = name(id)),
                 data.model = list(attributes = list(list(name = "id",
                                                          type = "numeric",
                                                          default = "ktools::uuid()")),
                                   skip = "id",
                                   hide = "id"))

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
#' @noRd
#'
#' @examples
#' ci_append(c_create("prj"),
#'                    ci_create(id = "a", path = "."))

ci_append <- function(config, ...){

  # -- secure against NULL
  args <- Filter(Negate(is.null), list(...))

  # -- secure against duplicated items
  candidates <- c_items(list(items = args))
  rejected <- duplicated(candidates) | candidates %in% c_items(config)
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
#' @param item the name (id) of the item group
#' @param where a list(position = c("before", "after"), item = "foo")
#'
#' @returns the new config
#' @noRd
#'
#' @examples
#' \dontrun{
#' ci_move(config, item = "bar", where = list(position = "before", item = "foo"))
#' }

ci_move <- function(config, item, where){

  # -- get item list
  item_list <- c_items(config)

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
#' @param item the name (id) of the item group
#'
#' @returns the new config
#' @noRd
#'
#' @examples
#' \dontrun{
#' ci_drop(config, item = "foo")
#' }

ci_drop <- function(config, item){

  # -- get item index & drop
  # secure against missing item
  if(is.na(idx <- ci_position(config, item)))
    return(config)
  else
    config$items <- config$items[-idx]

  # -- return
  config

}


#' Sort Items
#'
#' @param config the yaml config
#' @param item the name (id) of the item group
#' @param sort a character string
#'
#' @details
#' `sort` will be used to order the items.
#' Comma should be used between attribute names.
#' Wrap attribute name with desc() to indicate descending order.
#'
#' @returns the new config
#' @noRd
#'
#' @examples
#' \dontrun{
#' # define sorting
#' ci_sort(config, item, sort = "date, value")
#' ci_sort(config, item, sort = "desc(date), value")
#'
#' # reset sorting
#' ci_sort(config, item, sort = NULL)
#' }

ci_sort <- function(config, item, sort = NULL){

  # -- get item index
  if(is.na(idx <- ci_position(config, item)))
    return(config)

  # -- update sort
  config$items[[idx]]$data.model$sort <- if(is.null(sort) || sort == "") NULL else sort

  # -- return
  config

}


#' Item Row Order
#'
#' @description
#' Getter function that returns the ordering info of an item.
#'
#' @param config the config list
#' @param item the name (id) of the item group
#'
#' @returns a character string or `NA` if `ìtem` is missing.
#' @noRd
#'
#' @examples
#' \dontrun{
#' ci_row_order(config, item = "foo")
#' }

ci_row_order <- function(config, item){

  # -- get item index
  if(is.na(idx <- ci_position(config, item)))
    return(NA)

  # -- return
  config$items[[idx]]$data.model$sort

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
#' @noRd
#'
#' @examples
#' \dontrun{
#' ca_create(name = "att_1", type = "integer")
#' }

ca_create <- function(name, type, class.arg = NULL, values = NULL, default = NULL){

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
#' @param item the name (id) of the item group
#' @param ... one or several attribute config(s)
#'
#' @returns the new config
#' @noRd
#'
#' @examples
#' \dontrun{
#' ca_append(config, item = foo,
#'                         attribute = ca_create(name = "bar", type "numeric"))
#' }

ca_append <- function(config, item, ...){

  # -- item position
  if(is.na(item_idx <- ci_position(config, item)))
    return(config)

  # -- loop over ...
  for(attribute in list(...)){

    # -- secure from duplicated attribute names
    reserved <- c_attributes(config, item)
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
#' @param item the name (id) of the item group
#' @param attribute the attribute config
#'
#' @returns the new config
#' @noRd
#'
#' @examples
#' \dontrun{
#' ca_update(config, item = foo,
#'                         attribute = ca_create(name = "bar", type "numeric"))
#' }

ca_update <- function(config, item, attribute){

  # -- secure against forbidden actions
  if(attribute$name == "id"){
    warning("Updating the ", crayon::blue("id"), " attribute is forbidden.", call. = FALSE)
    return(config)}

  # -- attribute & item positions
  # attribute will check both exist
  if(is.na(attribute_idx <- ca_position(config, item, attribute$name)))
     return(config)
  item_idx <- ci_position(config, item)

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
#' @param item the name (id) of the item group
#' @param behavior which behavior to manipulate ("skip", "refresh" or "hide")
#' @param ... the name of the attribute(s)
#' @param set a logical (default = TRUE) if the behavior should be set or unset
#'
#' @returns a character vector
#' @noRd
#'
#' @examples
#' \dontrun{
#' ca_behavior(config, item = "foo", behavior = "skip", "id")
#' ca_behavior(config, item = "foo", behavior = "hide", "id", set = FALSE)
#' }

ca_behavior <- function(config, item, behavior, ..., set = TRUE){

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
    attributes <- attributes[attributes %in% ci_behavior(config, item)]}

  # -- get item index
  # already checked above
  item_idx <- ci_position(config, item)

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
#' @param item the name (id) of the item group
#' @param behavior the name of the behavior (default = "skip")
#'
#' @details
#' Behaviors:
#' - "skip" the default
#' - "refresh"
#' - "hide"
#'
#' @returns a character vector or NULL
#' @noRd
#'
#' @examples
#' \dontrun{
#' ci_behavior(config, item = "foo")
#' }

ci_behavior <- function(config, item, behavior = c("skip", "refresh", "hide")){

  # -- check arg
  behavior <- match.arg(behavior)

  # -- secure against missing item
  if(is.na(idx <- ci_position(config, item)))
    NULL
  else
    config$items[[idx]]$data.model[[behavior]]

}


#' Move Attribute
#'
#' @param config the yaml config
#' @param item the name (id) of the item group
#' @param attribute the name of the attribute to move
#' @param where a list(position = c("before", "after"), attribute = "foo")
#'
#' @returns the new config
#' @noRd
#'
#' @examples
#' \dontrun{
#' ca_move(config, "item_1", "att_1", list(position = "after", attribute = "att_2"))
#' }

ca_move <- function(config, item, attribute, where){

  # -- get target index
  target_idx <-  ca_position(config, item, where$attribute)
  if(where$position == "before")
    target_idx <- target_idx - 1

  # -- reorder attribute indexes
  att_list <- c_attributes(config, item)
  att_order <- append(att_list[!att_list %in% attribute], attribute, after = target_idx)

  # -- reorder attributes
  item_idx <- ci_position(config, item)
  config$items[[item_idx]]$data.model$attributes <- config$items[[item_idx]]$data.model$attributes[match(att_order, att_list)]

  # -- return
  config

}


#' Drop Attribute
#'
#' @param config the yaml config
#' @param item the name (id) of the item group
#' @param attribute the name of the attribute to drop
#'
#' @returns the new yaml config
#' @noRd
#'
#' @examples
#' \dontrun{
#' ca_drop(config, item = "foo", attribute = "att_1")
#' }

ca_drop <- function(config, item, attribute){

  # -- idx to drop
  # secure against missing item / attribute
  if(is.na(idx_to_drop <- ca_position(config, item, attribute))){
    return(config)}

  # -- item index
  item_idx <- ci_position(config, item)

  # -- drop attribute
  config$items[[item_idx]]$data.model$attributes <- config$items[[item_idx]]$data.model$attributes[-idx_to_drop]

  # -- update hide, skip & refresh
  config <- config |>
    ca_behavior(item, behavior = "hide", set = FALSE) |>
    ca_behavior(item, behavior = "skip", set = FALSE) |>
    ca_behavior(item, behavior = "refresh", set = FALSE)

  # -- return
  config

}
