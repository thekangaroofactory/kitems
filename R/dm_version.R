

#' Check Data Model Version
#'
#' @param data.model a data.frame of the data model
#'
#' @details
#' Data model version is required from v.0.7.1
#' This function will check whether the data model has a version (attribute) or not
#' as well as if the data model requires a migration
#'
#' It works both within a Shiny app context or at the console
#' It is recommended that this check is performed after installing a new version of
#' the package.
#'
#' @return a vector c(migration = TRUE/FALSE, comment = "message")
#' @export
#'
#' @examples
#' \dontrun{
#' dm_version(data.model = mydatamodel)
#' }

dm_version <- function(data.model){

  # -- Check if has a version
  if(!"version" %in% names(attributes(data.model))){

    warning("Data model has no version \nRun admin() to fix it")
    return(c(migration = TRUE, comment = "Data model has no version"))

  } else

    # -- Check data.model version (vs package version)
    if(attributes(data.model)$version != DATA_MODEL_VERSION){

      warning("Data model requires migration! \nRun admin() to fix it")
      return(c(migration = TRUE, comment = "Data model version is obsolete"))

    }

  # -- return (default)
  c(migration = FALSE, comment = "Data model is up to date")

}
