

#' Data model admin page
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples

admin_ui <- function(id){

  # namespace
  ns <- NS(id)

  # UI
  tagList(
  h3(paste(id, "- Admin view")),
  wellPanel(

    #
    fluidRow(column(width = 2,
                    p("Actions"),
                    uiOutput(ns("action_buttons"))),

             column(width = 10,
                    p("Raw Table"),
                    DT::DTOutput(ns("raw_item_table"))))),

  wellPanel(

    fluidRow(column(width = 2,
                    p("Actions"),
                    uiOutput(ns("filter_buttons")),
                    p("Column name mask applied by default:",br(),
                    "- replace dot, underscore with space",br(),
                    "- capitalize first letters")),

             column(width = 10,
                    p("Filtered Table"),
                    DT::DTOutput(ns("view_item_table"))))),



  )

}
