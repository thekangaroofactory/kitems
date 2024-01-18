

#' Title
#'
#' @param data.model
#' @param items
#'
#' @return
#' @export
#'
#' @examples

dm_check_integrity <- function(data.model, items, template = NULL){

  cat("Checking data model integrity \n")
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
