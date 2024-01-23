

#' Load data
#'
#' @param data.model a data.frame containing the data model
#' @param file the file name
#' @param path the path to the file
#' @param create a logical to indicate if missing file should be created or not
#'
#' @return the data (items)
#' @export
#'
#' @examples
#' item_load(data.model = mydatamodel, file = "mydata.csv", path = "path/to/my/data", create = TRUE)


item_load <- function(data.model, file, path, create){

  # -- Extract colClasses from data model
  col.classes <- dm_colClasses(data.model)

  # -- Try load (see read_data for details about returns)
  items <- kfiles::read_data(file = file,
                             path = path$data,
                             colClasses = col.classes,
                             create = create)

  # -- check output size (will trigger showing the create data btn)
  if(all(dim(items) == c(0,0)))
    items <- NULL

  cat("Read data done \n")

  # -- return
  items

}
