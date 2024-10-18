

#' Data model delete preview modal
#'
#' @param hasItems a logical if there are items (items data frame not NULL)
#' @param dm.file a logical if data model file exists
#' @param item.file a logical if item file exists
#' @param autosave a logical if autosave is ON
#' @param id the id if the module
#' @param ns the namespace function to be used
#'
#' @return a modalDialog
#'
#' @examples
#' \dontrun{
#' dm_delete_preview(hasItems = TRUE,
#' dm.file = TRUE,
#' item.file = TRUE,
#' autosave = TRUE,
#' id = "mydata",
#' ns = ns)
#' }
#'

# -- function definition
dm_delete_preview <- function(hasItems = FALSE, dm.file = FALSE, item.file = FALSE, autosave = FALSE, id = NULL, ns) {

  # -- return
  modalDialog(title = "Delete data model",

              p("Danger: deleting a data model can't be undone! Do you confirm?", br(),

                # -- check items
                if(hasItems)
                  "- All items in session will be deleted", br(),

                # -- check dm file
                if(dm.file){
                  if(autosave)
                    "- Data model file will be deleted"
                  else
                    "- Data model file won't be deleted (autosave is off)"}),

              # -- check items file
              if(item.file & autosave)
                checkboxInput(inputId = ns("dz_delete_dm_items"), label = "Delete items file"),

              # -- confirm string
              p("Type the following string:", paste0("delete_", id)),
              textInput(inputId = ns("dz_delete_dm_string"),
                        label = ""),

              # -- footer
              footer = tagList(
                modalButton("Cancel"),
                actionButton(ns("dz_delete_dm_confirm"), "Delete")))

}
