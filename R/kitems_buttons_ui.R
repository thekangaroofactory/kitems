

# -- BTN: create item
create_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("create_btn"), inline = TRUE)

}


# -- BTN: delete item
delete_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("delete_btn"), inline = TRUE)

}
