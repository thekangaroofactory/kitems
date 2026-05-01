

#' Item Modal Dialog(s)
#'
#' @description
#' Produces a create / update / delete modal dialog.
#'
#' @param ... the content to be displayed in the modal dialog.
#' @param workflow a character string to indicate workflow (see details).
#' @param ns the namespace function to use in the dialog.
#'
#' @returns a modal dialog.
#' @export
#'
#' @details
#' Possible values for workflow are "create" (default), "update" or "delete".
#'
#' `...` is typically the output of the item_form() function
#' When `workflow = "delete"`, it will be ignored and replaced by a standard message.
#'
#' @examples
#' \dontrun{
#' item_dialog(workflow = "delete", ns)
#' }

item_dialog <- function(..., workflow = c("create", "update", "delete"), ns){

  # -- check argument
  workflow <- match.arg(workflow)

  # -- prepare
  title <- paste0(ktools::toupperfirst(workflow), " item", ifelse(workflow == "delete", "(s)", ""))
  content <- ifelse(workflow == "delete", "Danger: deleting item(s) can't be undone! Do you confirm?", ...)
  btn_id <- ns(paste("item", workflow, "confirm", sep = "_"))
  btn_label <- ktools::toupperfirst(workflow)

  # -- build dialog & return
  modalDialog(
    content,
    title = title,
    footer = tagList(
      modalButton("Cancel"),
      actionButton(inputId = btn_id,
                   label = btn_label)))

}
