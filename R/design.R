
# document arguments that the function understands (see ggplot help with aes)

# document single unnamed argument for piping the config
# if multiple unnamed, function will throw an error since
# it's not possible to identify / return the input config.

# design only covers attribute creation without fine tuning.
# This means it creates attribute(s) with name & type.
# use extend() to create an attribute with fine tuning.
# use hide(), avoid() & refresh() to set specific attribute behaviors.

# use cases:
# design()
# yaml |> design()

# design understands the following instructions:

# -- create config
# design(project = "foo")

# -- create (single) item
# config |> design(item = "foo")
# config |> design(item = list(id = "foo", description = "x"))

# -- create (multiple) items
# config |> design(items = c("foo", "bar"))
# config |> design(items = list(c(id = "foo", description = "x"),
#                               c(id = "bar", description = "z")))
# config |> design(items = list(c(id = "foo", description = "x"),
#                               "bar"))
#
# -- create (single) attribute
# config |> design(attribute = c(name = "foo", type = "integer"))
#
# -- create (multiple) attributes
# config |> design(item = "foo", attributes = list(c(name = "bar", type = "integer"),
#                                                  c(name = "zoo", type = "character")))

design <- function(...){

  # ////////////////////////////////////////////////////////////////////////////
  # Check arguments

  # -- get & check args
  args <- list(...)
  if(!length(args)){
    warning("At least one argument is required to design.")
    return(NULL)}

  # -- check for unnamed arg
  # assuming it's coming from piping the yaml config object
  # error on multiples unnamed args because there's no way to identify the config
  # & returning NULL may scratch the existing one!
  if("" %in% names(args)){
    if(sum(names(args) == "") > 1)
      stop("A single unnamed argument is allowed for the config object.")
    names(args)[which(names(args) == "")] <- "config"}


  # ////////////////////////////////////////////////////////////////////////////
  # Project

  # -- create config
  if("project" %in% names(args))
    return(config_create(args$project))


  # ////////////////////////////////////////////////////////////////////////////
  # Attribute
  # Before item otherwise instruction will be misunderstood

  if(all(c("config", "item", "attribute") %in% names(args)))
    return(
      do.call(config_attribute_append,
              c(list(args$config, args$item),
                lapply(if(is.list(args$attribute)) args$attribute else list(args$attribute),
                       function(x) do.call(config_attribute_create, as.list(x))))))


  # ////////////////////////////////////////////////////////////////////////////
  # Item
  # After attribute otherwise instruction will be misunderstood

  # -- create (single or multiple) item(s)
  # checks on id(s) performed in config_item_create
  if(all(c("config", "item") %in% names(args)))
    return(
      do.call(config_item_append,
              c(list(args$config),
                     lapply(args$item,
                            function(x) config_item_create(id = if(is.list(x)) x$id else x,
                                                           description = if(is.list(x)) x$description else NULL)))))

}
