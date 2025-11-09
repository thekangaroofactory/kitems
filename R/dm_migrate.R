

#' Migrate Data Model
#'
#' @param data.model a data.frame of the data model
#'
#' @return the migrated data.model or NA if no migration is required
#' @export
#'
#' @examples
#' \dontrun{
#' dm_migrate(data.model)
#' }

dm_migrate <- function(data.model){

  # -- data model version
  version <- attributes(data.model)$version
  catl("[dm_migrate] Data model input version =", version, debug = 1)
  dirty <- FALSE

  # -- migration @v0.5.2
  # add default.arg, sort.rank, sort.desc
  if(version < "0.5.2"){

    catl("[dm_migrate] Data model migration @v0.5.2", debug = 1)

    # -- check that new cols are not already in the data.model!
    new_cols <- c("default.arg", "sort.rank", "sort.desc")
    new_cols <- new_cols[!new_cols %in% names(data.model)]

    # -- add missing columns
    if(length(new_cols) > 0){
      message("[dm_migrate] Data model migration to v0.5.2, missing columns = ", new_cols)
      data.model[new_cols] <- DATA_MODEL_DEFAULTS[new_cols]
      attr(data.model, "version") <- "0.5.2"
      dirty <- TRUE}

  }


  # -- migration @v0.7.1
  # rename filter into display
  if(version < "0.7.1"){

    catl("[dm_migrate] Data model migration @v0.7.1", debug = 1)

    # -- rename column
    if("filter" %in% names(data.model)){
      message("[dm_migrate] Data model migration to v0.7.1, rename column filter into display")
      names(data.model)[names(data.model) == "filter"] <- "display"
      attr(data.model, "version") <- "0.7.1"
      dirty <- TRUE}

  }


  # -- force columns order
  # attribute version must be kept
  if(dirty){
    v <- attributes(data.model)$version
    data.model <- data.model[names(DATA_MODEL_COLCLASSES)]
    attr(data.model, "version") <- v}


  # -- force data.model version
  # so that migration is done once per package update
  if(attributes(data.model)$version != as.character(packageVersion("kitems"))){
    attr(data.model, "version") <- as.character(packageVersion("kitems"))
    message("[dm_migrate] Data model version updated to ", attributes(data.model)$version)
    dirty <- TRUE}


  # -- return
  if(dirty) data.model else NA

}
