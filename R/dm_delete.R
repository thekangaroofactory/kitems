

#' Delete data model
#'
#' @param data.model the reference of the data model reactive value
#' @param items the reference of the items reactive value
#' @param dm_url the url (path + filename) of the data model
#' @param items_url the url (path + filename) of the items
#' @param autosave logical if the data should be saved
#' @param item.file a logical if the item file should be deleted
#'
#' @examples
#' \dontrun{
#' dm_delete(data.model = mydata$data_model,
#' items = mydata$items,
#' dm_url,
#' items_url,
#' autosave = TRUE,
#' item.file = TRUE)
#' }

# -- function definition
dm_delete <- function(data.model, items, dm_url, items_url, autosave, item.file){

  # -- delete items
  if(!is.null(items()))
    items(NULL)

  # -- delete data model & file
  data.model(NULL)
  if(file.exists(dm_url) & autosave)
    unlink(dm_url)

  # -- delete items file
  if(file.exists(items_url) & autosave)
    if(item.file)
      unlink(items_url)

}
