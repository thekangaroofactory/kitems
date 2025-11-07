

#' Check data model integrity
#'
#' @param data.model a \emph{mandatory} data model
#' @param items a \emph{mandatory} item data.frame
#' @param template an optional data.frame(name = c(...), type = c(...)) to be used to force attribute classes
#'
#' @return if data model matches with the data, TRUE will be returned. Otherwise an updated data model will be returned.
#' @export
#'
#' @details
#'
#' In case an attribute is missing from the data model, it will be added with either a type matching the template
#' one or a guessed one (using the class() function).
#'
#' In case an extra attribute is found in the data model as compared to the items, it will be dropped from the
#' data model.
#'
#' @examples
#' \dontrun{
#' feedback <- dm_integrity(mydatamodel, myitems)
#' if(!is.logical(feedback))
#'   mydatamodel <- feedback
#' }

dm_integrity <- function(data.model, items, template = NULL){

  # -- init
  integrity <- TRUE

  # -- Check for missing attributes (columns in item data.frame not in data model)
  missing_att <- colnames(items)[(!colnames(items) %in% data.model$name)]
  if(!identical(missing_att, character(0))){

    # -- nb attribute to add
    n <- length(missing_att)

    catl("[Warning]", n, "missing attribute(s) in data model:", missing_att, debug = 1)
    integrity <- FALSE

    # -- helper: get unique value for class()
    helper <- function(x){
      class(x)[1]}

    # -- Get class from items
    missing_types <- sapply(items[missing_att], helper)
    missing_types <- unlist(missing_types)

    # -- Set defaults
    # note: sequence to prepare for update from template
    missing_default_val <- rep(NA, n)
    missing_default_fun <- rep(NA, n)
    missing_default_arg <- rep(NA, n)
    missing_skip <- character()
    missing_display <- character()

    # -- Set names
    names(missing_default_val) <- missing_att
    names(missing_default_fun) <- missing_att
    names(missing_default_arg) <- missing_att

    # -- Check argument
    if(!is.null(template)){

      # -- Check if any attribute is part of template
      if(any(missing_att %in% TEMPLATE_DATA_MODEL$name)){

        # -- get index & drop NAs (attribute not matching in template)
        idx <- match(names(missing_types), template$name)
        idx <- idx[!is.na(idx)]

        catl("-- attribute(s) in template:", template$name[idx], level = 2)

        # -- update parameters
        missing_types[names(missing_types) %in% template$name][] <- template[idx, ]$type
        missing_default_val[names(missing_default_val) %in% template$name][] <- template[idx, ]$default.val
        missing_default_fun[names(missing_default_fun) %in% template$name][] <- template[idx, ]$default.fun
        missing_default_arg[names(missing_default_arg) %in% template$name][] <- template[idx, ]$default.arg


        missing_skip <- template[idx, ][template[idx, ]$skip, 'name']
        missing_display <- template[idx, ][template[idx, ]$display, 'name']

      }}

    # -- Add missing attributes
    data.model <- attribute_create(data.model = data.model,
                                   name = missing_att,
                                   type = missing_types,
                                   default.val = missing_default_val,
                                   default.fun = missing_default_fun,
                                   default.arg = missing_default_arg,
                                   skip = missing_skip,
                                   display = missing_display)

  }

  # -- Check for missing columns (attribute in data model not in item data.frame)
  extra_att <- data.model$name[!data.model$name %in% colnames(items)]
  if(!identical(extra_att, character(0))){

    catl("[Warning] Extra attribute in data model:", extra_att, debug = 1)
    integrity <- FALSE

    # -- Drop extra rows
    data.model <- data.model[!data.model$name %in% extra_att, ]

  }

  # -- Check for data model version
  dm_colClasses <- lapply(data.model, class)
  missing_col <- DATA_MODEL_COLCLASSES[!names(DATA_MODEL_COLCLASSES) %in% names(dm_colClasses)]

  # -- migrate
  if(length(missing_col > 0)){

    catl("[Info] Data model migration is needed", debug = 1)
    integrity <- FALSE

    # -- call migration
    data.model <- dm_migrate(data.model, names(missing_col))

    # -- check column order
    if(!identical(names(data.model), names(DATA_MODEL_COLCLASSES))){
      catl("[Info] Reordering data model columns", level = 2)
      data.model <- data.model[names(DATA_MODEL_COLCLASSES)]}}


  # -- Return
  if(!integrity)
    data.model
  else
    TRUE

}
