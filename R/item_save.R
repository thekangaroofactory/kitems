

#' Save data
#'
#' @param data a data.frame containing the data to be saved
#' @param file the url of the file (including path & .csv extension)
#'
#' @export
#'
#' @details
#' File connector: if file is not NULL, then data is saved to .csv
#'
#' @examples
#' \dontrun{
#' # -- File connector:
#' item_save(data = mydata, file = "path/to/my/data/mydata.csv")
#' }


item_save <- function(data, file = NULL){

  # --------------------------------------------------------------------------
  # Ensure timezone continuity #269
  # --------------------------------------------------------------------------

  # -- get datetime index
  # To avoid adding data.model to the function signature, get classes from data
  classes <- lapply(data, function(x) class(x)[1])
  idx <- which(classes == "POSIXct")

  # -- convert to ISO 8601 character format
  if(length(idx) > 0){
    catl("[item_save] Convert datetime attribute(s) to ISO-8601 =", names(data[idx]))
    data[idx] <- format(data[idx], "%FT%H:%M:%S%z")}


  # ----------------------------------------------------------------------------
  # Connector: file (.csv)
  # ----------------------------------------------------------------------------

  if(!is.null(file))
    kfiles::write_data(data, file)

  # ----------------------------------------------------------------------------

}
