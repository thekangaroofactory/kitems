



new_item_btn <- function(id){

  # namespace
  ns <- NS(id)

  actionButton(inputId = "btn_new_item",
               label = "New")

}
