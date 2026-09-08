

#' Data Model Migration
#'
#' @description
#' Execute the migration procedure on a data model.
#'
#' @param data.model a data.frame of the data model.
#'
#' @return The migrated data model or `NA` if no migration is required.
#' @export
#'
#' @examples
#' \dontrun{
#' dm_migrate(data.model)
#' }

dm_migrate <- function(data.model){

  # -- data model version
  version <- attributes(data.model)$version
  message("Data model migration start...")
  message("- data model version =", version)
  dirty <- FALSE

  # -- migration @v0.5.2
  # add default.arg, sort.rank, sort.desc
  if(version < "0.5.2"){

    message(">> Data model migration @v0.5.2")

    # -- check that new cols are not already in the data.model!
    new_cols <- c("default.arg", "sort.rank", "sort.desc")
    new_cols <- new_cols[!new_cols %in% names(data.model)]

    # -- add missing columns
    if(length(new_cols) > 0){
      message("- add missing columns = ", new_cols)
      data.model[new_cols] <- DATA_MODEL_DEFAULTS[new_cols]
      attr(data.model, "version") <- "0.5.2"
      dirty <- TRUE}

  }


  # -- migration @v0.7.1
  # rename filter into display
  if(version < "0.7.1"){

    message(">> Data model migration @v0.7.1")

    # -- rename column & update value
    # need to invert values otherwise wrong columns will be shown! #577
    if("filter" %in% names(data.model)){
      message("- rename filter column into display")
      names(data.model)[names(data.model) == "filter"] <- "display"
      data.model$display <- !data.model$display
      attr(data.model, "version") <- "0.7.1"
      dirty <- TRUE}

  }


  # -- migration @v0.8.0
  # add class.arg, values, refresh
  # drop default.arg & merge into default.fun
  if(version < "0.8.0"){

    message(">> Data model migration @v0.8.0")

    # -- check that new cols are not already in the data.model!
    new_cols <- c("class.arg", "values", "refresh")
    new_cols <- new_cols[!new_cols %in% names(data.model)]

    # -- add missing columns
    if(length(new_cols) > 0){
      message("- add missing column(s) = ", paste(new_cols, collapse = " | "))
      data.model[new_cols] <- DATA_MODEL_DEFAULTS[new_cols]
      dirty <- TRUE}

    # drop default.arg & merge into default.fun
    if("default.arg" %in% names(data.model)){
      message("- drop column = default.arg")
      data.model <- data.model |> dplyr::mutate(default.fun = dplyr::case_when(!is.na(default.arg) ~ stringr::str_replace(default.arg, "list", default.fun),
                                                         .default = NA))
      data.model$default.arg <- NULL
      dirty <- TRUE}

    # drop default.fun & default.val & merge into default
    if(all(c("default.val", "default.fun") %in% names(data.model))){
      message("- merge columns = default.fun | default.val")
      data.model <- data.model |> dplyr::mutate(default = dplyr::case_when(!is.na(default.fun) ~  default.fun, !is.na(default.val) ~ default.val, .default = NA))
      data.model$default.fun <- NULL
      data.model$default.val <- NULL
      dirty <- TRUE}

    # update version
    attr(data.model, "version") <- "0.8.0"

  }

  # -- force columns order
  # attribute version must be kept
  if(dirty){
    v <- attributes(data.model)$version
    data.model <- data.model[names(DATA_MODEL_COLCLASSES)]
    attr(data.model, "version") <- v}

  if(dirty){
    message("Data model migration done.")
    message("- data model version =", attributes(data.model)$version)}

  # -- return
  if(dirty) data.model else NA

}
