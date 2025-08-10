

#' Item Modal Dialog
#'
#' @param data.model a data.frame of the data model
#' @param items a data.frame of the items
#' @param workflow a character string to indicate workflow (see details)
#' @param item a data.frame of the item to update (when update = TRUE)
#' @param shortcut a logical (default FALSE) if shortcuts should be activated
#' @param ns the intented namespace function to use in the dialog
#'
#' @returns a modal dialog
#' @export
#'
#' @details
#' Possible values for workflow are c("create", "update", "delete")
#' "create" is the default
#'
#' @examples
#' \dontrun{
#' item_dialog(data.model, items, update = FALSE, item = NULL, shortcut = FALSE, ns)
#' }

item_dialog <- function(data.model = NULL, items = NULL, workflow = c("create", "update", "delete"), item = NULL, shortcut = FALSE, ns){

  # -- check argument
  workflow <- match.arg(workflow)

  # -- create
  if(workflow == "create")
    dialog <- modalDialog(
      item_form(data.model = data.model,
                items = items,
                shortcut = shortcut,
                ns = ns),
      title = "Create item",
      footer = tagList(
        modalButton("Cancel"),
        actionButton(inputId = ns(("item_create_confirm")),
                     label = "Create")))

  # -- update
  if(workflow == "update")
    dialog <- modalDialog(
      item_form(data.model = data.model,
                items = items,
                update = TRUE,
                item = item,
                shortcut = shortcut,
                ns = ns),
      title = "Update item",
      footer = tagList(
        modalButton("Cancel"),
        actionButton(inputId = ns(("item_update_confirm")),
                     label = "Update")))

  # -- delete
  if(workflow == "delete")
    dialog <- modalDialog(title = "Delete item(s)",
                "Danger: deleting item(s) can't be undone! Do you confirm?",
                footer = tagList(
                  modalButton("Cancel"),
                  actionButton(ns("item_delete_confirm"), "Delete")))

  # -- return
  dialog

}
