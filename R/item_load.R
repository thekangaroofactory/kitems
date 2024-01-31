

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

  # -- return
  items

}
