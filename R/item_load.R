

#' Load data
#'
#' @param data.model a data.frame containing the data model
#' @param file an optional file name (including .csv extension)
#' @param path an optional path to the file
#' @param create a logical (default = TRUE) to indicate if missing file should be created or not
#'
#' @return the data (items)
#' @export
#'
#' @details
#' File connector: if file is not NULL, then data are loaded from the given .csv
#'
#' @examples
#' \dontrun{
#' # -- File connector:
#' item_load(data.model = mydatamodel, file = "mydata.csv", path = "path/to/my/data", create = TRUE)
#' }


item_load <- function(data.model, file = NULL, path = NULL, create = TRUE){

  # -- Init
  items <- NULL

  # -- Extract colClasses from data model
  col.classes <- dm_colClasses(data.model)


  # ----------------------------------------------------------------------------
  # Ensure timezone continuity #269
  # ----------------------------------------------------------------------------
  # datetime will be read as character (and converted later)

  # -- get datetime index & name
  idx_ct <- which(col.classes %in% "POSIXct")
  names_ct <- names(col.classes[idx_ct])

  # -- convert classes
  if(length(idx_ct) > 0)
    col.classes[idx_ct] <- "character"


  # ----------------------------------------------------------------------------
  # Connector: file (.csv)
  # ----------------------------------------------------------------------------
  if(!is.null(file))

    # -- Try load (see read_data for details about returns)
    items <- kfiles::read_data(file = file,
                               path = path,
                               colClasses = col.classes,
                               create = create)

  # ----------------------------------------------------------------------------


  # -- check output size (will trigger showing the create data btn)
  if(all(dim(items) == c(0,0)))
    items <- NULL

  else {

    # --------------------------------------------------------------------------
    # Ensure timezone continuity #269
    # --------------------------------------------------------------------------
    # convert ISO 8601 character vector to POSIXct
    # output will get an extra tzone attribute compared to original object,
    # but values are the same

    # -- POSIXct
    # check if items has any of the expected attributes #326 #359
    if(length(idx_ct) > 0)
      if(any(names_ct %in% names(items))){

        # -- because any is used, clean potential missing attribute(s)
        names_ct <- names_ct[names_ct %in% names(items)]

        catl("[item_load] Converting attribute(s) to POSIXct =", names_ct)
        items[names_ct] <- lapply(items[names_ct], function(x) as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S%z", tz = ""))}

  }


  # -- return
  items

}
