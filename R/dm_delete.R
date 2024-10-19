

#' Delete data model
#'
#' @param data.model the reference of the data model reactive value
#' @param items the reference of the items reactive value
#' @param dm_url the url (path + filename) of the data model
#' @param items_url the url (path + filename) of the items
#' @param autosave logical if the data should be saved
#' @param item.file a logical if the item file should be deleted
#' @param notify a logical if a shiny notification should be displayed (default = FALSE)
#' @param MODULE an optional string to display in the notification
#'
#' @examples
#' \dontrun{
#' dm_delete(data.model = mydata$data_model,
#' items = mydata$items,
#' dm_url,
#' items_url,
#' autosave = TRUE,
#' item.file = TRUE,
#' notify = TRUE,
#' MODULE = "mydata")
#' }

# -- function definition
dm_delete <- function(data.model, items, dm_url, items_url, autosave, item.file, notify = FALSE, MODULE = NULL){

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

  # -- notify
  if(notify)
    showNotification(paste(MODULE, "Data model deleted."), type = "warning")

}
