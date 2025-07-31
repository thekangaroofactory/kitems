

#' Item Modal Dialog
#'
#' @param data.model a data.frame of the data model
#' @param items a data.frame of the items
#' @param update a logical (default FALSE) if the intent it to update an item
#' @param item a data.frame of the item to update (when update = TRUE)
#' @param shortcut a logical (default FALSE) if shortcuts should be activated
#' @param ns the intented namespace function to use in the dialog
#'
#' @returns a modal dialog
#' @export
#'
#' @examples
#' \notrun{
#' item_dialog(data.model, items, update = FALSE, item = NULL, shortcut = FALSE, ns)
#' }

item_dialog <- function(data.model, items, update = FALSE, item = NULL, shortcut = FALSE, ns){

  # -- return
  modalDialog(
    item_form(data.model = data.model,
              items = items,
              update = update,
              item = item,
              shortcut = shortcut,
              ns = ns),
    title = ifelse(update, "Update item", "Create item"),
    footer = tagList(
      modalButton("Cancel"),
      actionButton(inputId = ns(paste0("item_", ifelse(update, "update", "create"), "_confirm")),
                   label = ifelse(update, "Update", "Create"))))

}
