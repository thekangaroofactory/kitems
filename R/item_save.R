

#' Save Items
#'
#' @description
#' Saves the items data.frame.
#'
#' @param data a data.frame containing the data to be saved.
#' @param connector a list parameters that will passed to iker::save_data() call.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # -- File connector:
#' item_save(data = mydata, connector = list(type = "file", file = "path/to/my/data/mydata.csv")
#' }

item_save <- function(data, connector){

  # -- case when all items have been deleted
  if(is.null(data)){
    if(file.exists(file.path(connector$path, connector$file))){
        success <- unlink(k_items_url)
        if(success == 1)
          warning("Item file could not be deleted. Delete it manually.")
        else
          catl(MODULE, "Item file has been deleted.")}
    } else
      iker::save_data(data, path = connector$path, file = connector$file)

}
