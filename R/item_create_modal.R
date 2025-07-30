
#' Item Dialog
#'
#' @param data.model a data.frame with the data model information
#' @param items a data.frame with the items
#' @param shortcut a logical if shortcuts are activated or not
#' @param ns a namespace function
#'
#' @examples
#' \dontrun{
#' item_create_modal(data.model, items, shortcut, ns)
#' }

item_create_modal <- function(data.model, items, shortcut, ns){

  # -- show dialog
  showModal(modalDialog(
    item_form(data.model = data.model,
              items = items,
              update = FALSE,
              item = NULL,
              shortcut = shortcut,
              ns = ns),
    title = "Create",
    footer = tagList(
      modalButton("Cancel"),
      actionButton(ns("item_create_confirm"), "Create"))))

}
