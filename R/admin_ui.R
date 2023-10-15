

#' Data model admin page
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples

admin_ui <- function(id){

  # -- Get namespace
  ns <- NS(id)

  # -- Define UI & return
  tagList(

    # --
    navlistPanel(

      # -- Title
      "Administration console",
      widths = c(2, 10),

      # -- Data model
      tabPanel(title = "Data model",

               wellPanel(h3(paste("Name: ", id)),
                         fluidRow(column(width = 12,
                                         uiOutput(ns("create_zone")))),

                         fluidRow(column(width = 2,
                                         p("Actions"),
                                         uiOutput(ns("action_buttons"))),

                                  column(width = 10,
                                         p("Table"),
                                         DT::DTOutput(ns("data_model")))),

                         fluidRow(column(width = 12,
                                         br(),
                                         uiOutput(ns("danger_btn")),
                                         uiOutput(ns("danger_zone")))))),

      # -- Raw table
      tabPanel(title = "Raw table",

               wellPanel(h3(paste("Name: ", id)),
                         fluidRow(column(width = 2,
                                         p("Actions"),
                                         uiOutput(ns("sort_buttons"))),

                                  column(width = 10,
                                         p("Raw Table"),
                                         DT::DTOutput(ns("raw_item_table")))))),

      # --View table
      tabPanel(title = "View",

               wellPanel(h3(paste("Name: ", id)),
                         fluidRow(column(width = 2,
                                         p("Actions"),
                                         uiOutput(ns("filter_buttons")),
                                         p("Column name mask applied by default:",br(),
                                           "- replace dot, underscore with space",br(),
                                           "- capitalize first letters")),

                                  column(width = 10,
                                         p("Filtered Table"),
                                         DT::DTOutput(ns("view_item_table"))))))))

}
