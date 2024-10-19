

#' Delete attribute
#'
#' @param k_data_model the reference of the data model reactive value
#' @param k_items the reference of the items reactive value
#' @param name the name of the attribute to delete
#' @param MODULE an optional string to be displayed in the notification
#' @param autosave a logical if autosave is ON
#' @param dm_url the url of the data model file
#' @param items_url the url of the item file
#' @param notify a logical if shiny notification should be fired
#'
#' @examples
#' \dontrun{
#' attribute_delete(k_data_model,
#' k_items,
#' name = "comment",
#' MODULE = "mydata",
#' autosave = TRUE,
#' dm_url = dm_url,
#' items_url = items_url,
#' notify = TRUE)
#' }
#'

attribute_delete <- function(k_data_model, k_items, name, MODULE = NULL, autosave = FALSE, dm_url = NULL, items_url = NULL, notify = FALSE){

  # -- drop column!
  cat(MODULE, "Drop attribute from all items \n")
  items <- k_items()
  items[name] <- NULL

  # -- update data model
  cat(MODULE, "Drop attribute from data model \n")
  dm <- k_data_model()
  dm <- dm[dm$name != name, ]


  # -- check for empty data model & store
  if(nrow(dm) == 0){
    cat(MODULE, "Warning! Empty Data model, cleaning data model & items \n")
    k_items(NULL)
    k_data_model(NULL)

    if(autosave){
      cat(MODULE, "Deleting data model & item files \n")
      unlink(dm_url)
      unlink(items_url)

      # -- notify
      if(notify)
        showNotification(paste(MODULE, "Empty data model deleted."), type = "message")}

  } else {
    k_items(items)
    k_data_model(dm)

    # -- notify
    if(notify)
      showNotification(paste(MODULE, "Attribute deleted."), type = "message")}

}
