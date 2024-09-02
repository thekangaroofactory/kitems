

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

  # ----------------------------------------------------------------------------
  # Connector: file (.csv)
  # ----------------------------------------------------------------------------

  if(!is.null(file))
    kfiles::write_data(data, file)

  # ----------------------------------------------------------------------------

}
