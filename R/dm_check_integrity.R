

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

  integrity <- TRUE

  # -- Check for missing attributes (columns in item data.frame not in data model)
  missing_att <- colnames(items)[(!colnames(items) %in% data.model$name)]
  if(!identical(missing_att, character(0))){

    cat("[Warning] Missing attribute in data model:", missing_att, "\n")
    integrity <- FALSE

    # -- Get class from data.frame & add attributes
    missing_types <- sapply(items[missing_att], class)

    # -- Force id attribute class to double (otherwise detected as numeric)
    if("id" %in% names(missing_types))
      missing_types[["id"]] <- "double"

    # -- Force attribute classes when part of template
    idx <- match(names(missing_types), template$name)
    idx <- idx[!is.na(idx)]
    missing_types[names(missing_types) %in% template$name][] <- template[idx, ]$type

    # -- Add missing attributes
    data.model <- dm_add_attribute(data.model, name = missing_att, type = missing_types)

  }

  # -- Check for missing columns (attribute in data model not in item data.frame)
  extra_att <- data.model$name[!data.model$name %in% colnames(items)]
  if(!identical(extra_att, character(0))){

    cat("[Warning] Extra attribute in data model:", extra_att, "\n")
    integrity <- FALSE

    # -- Drop extra rows
    data.model <- data.model[!data.model$name %in% extra_att, ]

  }

  # -- Return
  if(!integrity)
    data.model
  else
    TRUE

}
