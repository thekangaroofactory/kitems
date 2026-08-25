
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
# config |> design(item = c(id = "foo", description = "x"))

# -- create (multiple) items
# config |> design(item = "foo",
#                  item = "bar")
# config |> design(item = c(id = "foo", description = "x"),
#                         c(id = "bar", description = "z"))
# config |> design(item = c(id = "foo", description = "x"),
#                  item = "bar")
#
# -- create (single) attribute
# config |> design(item = "foo",
#                  attribute = c(item = "foo", name = "value", type = "integer"))
#
# -- create (multiple) attributes
# config |> design(item = "foo",
#                  attribute = c(item = "foo", name = "value", type = "integer"),
#                  attribute = c(item = "foo", name = "comment", type = "character"))
#
# -- dummy stuff
# design(dream = "draw me a sheep")

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
  # Check for multiple expressions

  if(length(names(args)[!names(args) %in% "config"]) > 1){

    # -- extract config (if so) & plans
    config <- args$config
    plans <- args[!names(args) %in% "config"]

    # -- loop over plans (recursive call)
    for(i in 1:length(plans))
      config <- do.call(design,
                        append(plans[i], list(config)))

    # -- make sure we don't go further
    return(config)}


  # ////////////////////////////////////////////////////////////////////////////
  # Project

  # -- create config
  if("project" %in% names(args))
    return(config_create(args$project))


  # ////////////////////////////////////////////////////////////////////////////
  # Item

  if(all(c("config", "item") %in% names(args)))
    return(
      args$config |>
        config_item_append(
          do.call(config_item_create,
                  as.list(args$item))))


  # ////////////////////////////////////////////////////////////////////////////
  # Attribute

  if(all(c("config", "attribute") %in% names(args)))
    return(
      args$config |>
        config_attribute_append(args$attribute["item"],
          do.call(config_attribute_create,
                  as.list(args$attribute[!names(args$attribute) %in% "item"]))))


  # ////////////////////////////////////////////////////////////////////////////
  # Didn't get what user's trying to do!
  warning("The design instruction could not be undertsood - check ?design.", call. = FALSE)

}
