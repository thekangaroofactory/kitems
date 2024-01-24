

#' Save data
#'
#' @param data a data.frame containing the data to be saved
#' @param file an optional file name (including .csv extension)
#' @param path an optional path to the file
#'
#' @export
#'
#' @details
#' File connector: if file is not NULL, then data is saved to .csv
#'
#' @examples
#' # -- File connector:
#' item_save(data = mydata, file = "mydata.csv", path = "path/to/my/data")


item_save <- function(data, file = NULL, path = NULL){

  # ----------------------------------------------------------------------------
  # Connector: file (.csv)
  # ----------------------------------------------------------------------------
  if(!is.null(file))

    # -- Write
    kfiles::write_data(data = data,
                       file = file,
                       path = path)


  # ----------------------------------------------------------------------------

}
