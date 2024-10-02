

#' Check data model
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
#' feedback <- dm_check_integrity(mydatamodel, myitems)
#' if(!is.logical(feedback))
#'   mydatamodel <- feedback
#' }

dm_check_integrity <- function(data.model, items, template = NULL){

  # -- init
  integrity <- TRUE

  # -- Check for missing attributes (columns in item data.frame not in data model)
  missing_att <- colnames(items)[(!colnames(items) %in% data.model$name)]
  if(!identical(missing_att, character(0))){

    # -- nb attribute to add
    n <- length(missing_att)

    cat("[Warning]", n, "missing attribute(s) in data model:", missing_att, "\n")
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
    missing_skip <- rep(FALSE, n)
    missing_filter <- rep(FALSE, n)

    # -- Set names
    names(missing_default_val) <- missing_att
    names(missing_default_fun) <- missing_att
    names(missing_default_arg) <- missing_att
    names(missing_skip) <- missing_att
    names(missing_filter) <- missing_att

    # -- Check argument
    if(!is.null(template)){

      # -- Check if any attribute is part of template
      if(any(missing_att %in% TEMPLATE_DATA_MODEL$name)){

        # -- get index & drop NAs (attribute not matching in template)
        idx <- match(names(missing_types), template$name)
        idx <- idx[!is.na(idx)]

        cat("-- attribute(s) in template:", template$name[idx], "\n")

        # -- update parameters
        missing_types[names(missing_types) %in% template$name][] <- template[idx, ]$type
        missing_default_val[names(missing_default_val) %in% template$name][] <- template[idx, ]$default.val
        missing_default_fun[names(missing_default_fun) %in% template$name][] <- template[idx, ]$default.fun
        missing_default_arg[names(missing_default_arg) %in% template$name][] <- template[idx, ]$default.arg
        missing_skip[names(missing_skip) %in% template$name][] <- template[idx, ]$filter
        missing_filter[names(missing_filter) %in% template$name][] <- template[idx, ]$skip

      }}

    # -- Add missing attributes
    data.model <- dm_add_attribute(data.model = data.model,
                                   name = missing_att,
                                   type = missing_types,
                                   default.val = missing_default_val,
                                   default.fun = missing_default_fun,
                                   default.arg = missing_default_arg,
                                   skip = names(missing_skip),
                                   filter = names(missing_filter))

  }

  # -- Check for missing columns (attribute in data model not in item data.frame)
  extra_att <- data.model$name[!data.model$name %in% colnames(items)]
  if(!identical(extra_att, character(0))){

    cat("[Warning] Extra attribute in data model:", extra_att, "\n")
    integrity <- FALSE

    # -- Drop extra rows
    data.model <- data.model[!data.model$name %in% extra_att, ]

  }

  # -- Check for data model version
  dm_colClasses <- lapply(data.model, class)
  missing_col <- DATA_MODEL_COLCLASSES[!names(DATA_MODEL_COLCLASSES) %in% names(dm_colClasses)]

  # -- migrate
  if(length(missing_col > 0)){

    cat("[Warning] Data model migration is needed \n")
    integrity <- FALSE

    # -- call migration
    data.model <- dm_migrate(data.model, names(missing_col))}

  # -- Return
  if(!integrity)
    data.model
  else
    TRUE

}
