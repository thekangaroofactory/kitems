

# -- BTN: new item
new_item_BTN <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  uiOutput(ns("new_item_btn"))

}


item_table_UI <- function(id){

  # -- namespace
  ns <- NS(id)

  # -- the table
  DT::DTOutput(ns("item_table"))

}

