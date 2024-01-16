

#' Title
#'
#' @param data.model
#' @param file
#' @param path
#' @param create
#'
#' @return
#' @export
#'
#' @examples


item_load <- function(data.model, file, path, create, MODULE = NULL){

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

  cat(MODULE, "Read data done \n")

  # -- return
  items

}
