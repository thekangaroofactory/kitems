

#' Data Model Integrity
#'
#' @description
#' Check the data model integrity.
#'
#' @param data.model a data.frame of the data model.
#' @param items a data.frame of the items.
#' @param fix a logical (default = `FALSE`) if `data.model` should be fixed.
#' @param template a logical (default = `FALSE`) if attribute template should be used (see details).
#' @param n the maximum number (default = 100) of `items` rows used to compute an attribute class (see details)
#'
#' @return if `data.model` matches with the `items`, `TRUE` will be returned. Otherwise an updated data model will be returned.
#' @export
#'
#' @details
#' When `fix` is FALSE, an error will be raised if a problem is detected (on first occurrence).
#'
#' Checks if `data.model` matches with the expected data.frame structure.
#'
#' In case an attribute of `items` is missing from `data.model`, it will be added to the data model (`fix = TRUE`).
#' When `template = TRUE` it will check if the missing attribute(s) matches with en entry in the attribute template
#' so that they will be added with parameters from the template.
#' If not found (or when `template = FALSE`), it will guess the class of the missing attribute(s) from the `n` first rows
#' of the `items`.
#'
#' In case an extra attribute is found in the `data.model` as compared to the `items`, it will be dropped from the
#' data model.
#'
#' @examples
#' \dontrun{
#' feedback <- dm_integrity(mydatamodel, myitems, fix = TRUE)
#' }

dm_integrity <- function(data.model, items, fix = FALSE, template = FALSE, n = 100){

  # -- init
  integrity <- TRUE

  # ////////////////////////////////////////////////////////////////////////////

  # -- check structure
  # data.model has expected columns
  if(any(!names(DATA_MODEL_COLCLASSES) %in% colnames(data.model)))
    if(!fix)
      stop("Data model has wrong structure. Check version().")


  # ////////////////////////////////////////////////////////////////////////////

  # -- Check for missing attributes
  # columns in items not in data.model
  missing_names <- colnames(items)[(!colnames(items) %in% data.model$name)]
  if(!identical(missing_names, character(0))){

    # -- check mode, just throw an error
    if(!fix)
      stop("Missing attribute(s): ", missing_names)

    # -- init
    catl(length(missing_names), "missing attribute(s) in data model:", missing_names, debug = 1)
    integrity <- FALSE


    # //////////////////////////////////////////////////////////////////////////

    # -- When template is used
    if(template){

      # -- Check if any attribute is part of template
      idx <- match(missing_names, TEMPLATE_ATTRIBUTES$name)
      if(!all(is.na(idx))){

        # -- keep matching attributes
        missing_template <- TEMPLATE_ATTRIBUTES[idx, ]
        catl("-- attribute(s) in template:", missing_template$name, level = 2)

        # -- add to data.model
        # TEMPLATE_ATTRIBUTES is built using attribute_create so no need to
        # create those attributes again
        data.model <- dplyr::bind_rows(data.model, missing_template)

        # -- update missing
        missing_names <- missing_names[!missing_names %in% missing_template]}}


    # //////////////////////////////////////////////////////////////////////////
    # Remaining attributes
    # (or all if template FALSE or not found in template)

    if(!identical(missing_names, character(0))){

      # -- Get class from items
      # set limit to avoid computing class on huge column(s)
      # we take 1st class cause POSIXct will return "POSIXct" "POSIXt"
      nb_row <- if(nrow(items) > n) n else nrow(items)
      missing_types <- sapply(items[nb_row, missing_names], function(x) class(x)[1])

      # -- Add missing attributes
      # defaults will be taken from attribute_create
      data.model <- attribute_create(data.model = data.model,
                                     name = missing_names,
                                     class = missing_types)}}


  # ////////////////////////////////////////////////////////////////////////////

  # -- Check for extra attributes
  # attribute in data.model not in items
  extra_att <- data.model$name[!data.model$name %in% colnames(items)]
  if(!identical(extra_att, character(0))){

    # -- check mode, just throw an error
    if(!fix)
      stop("Extra attribute(s) in data model: ", extra_att)

    # -- Drop extra rows
    catl("Extra attribute(s) in data model:", extra_att, debug = 1)
    data.model <- data.model[!data.model$name %in% extra_att, ]
    integrity <- FALSE}


  # ////////////////////////////////////////////////////////////////////////////

  # -- reorder attributes to match items
  if(!integrity)
    data.model <- data.model[match(colnames(items), data.model$name), ]


  # ////////////////////////////////////////////////////////////////////////////

  # -- Return
  if(!integrity) data.model else TRUE

}
