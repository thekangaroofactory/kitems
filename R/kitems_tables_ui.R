
item_table_UI <- function(id){

  # -- namespace
  ns <- NS(id)

  # -- the table
  DT::DTOutput(ns("item_table"))

}

