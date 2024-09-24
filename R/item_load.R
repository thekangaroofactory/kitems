

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

  # -- get datetime index
  idx_ct <- which(col.classes %in% "POSIXct")
  idx_lt <- which(col.classes %in% c("POSIXlt"))

  # -- convert classes
  if(length(c(idx_ct, idx_lt)) > 0)
    col.classes[c(idx_ct, idx_lt)] <- "character"


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
    # convert ISO 8601 character vector to POSIXct, POSIXlt
    # output will get an extra tzone attribute compared to original object,
    # but values are the same

    DEBUG_items <<- items

    # -- POSIXct
    if(length(idx_ct) > 0){
      cat("[item_load] Converting attribute(s) to POSIXct =", names(col.classes[idx_ct]), "\n")
      items[idx_ct] <- lapply(items[idx_ct], function(x) as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S%z", tz = ""))}

    # -- POSIXlt
    if(length(idx_lt) > 0){
      cat("[item_load] Converting attribute(s) to POSIXlt =", names(col.classes[idx_lt]), "\n")
      items[idx_lt] <- lapply(items[idx_lt], function(x) as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S%z", tz = ""))}

  }


  # -- return
  items

}
