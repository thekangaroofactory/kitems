

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

                         conditionalPanel(condition ="output.hasDataModel == false", ns = ns,
                                          fluidRow(column(width = 12,
                                                          p("No data model found. You need to create one to start."),
                                                          uiOutput(ns("admin_dm_create"))))),

                         conditionalPanel(condition ="output.hasDataModel == true", ns = ns,

                                          fluidRow(column(width = 2,

                                                          p("Actions"),
                                                          uiOutput(ns("dm_add_att"))),

                                                   column(width = 10,
                                                          p("Table"),
                                                          DT::DTOutput(ns("data_model")))),

                                          fluidRow(column(width = 12,
                                                          br(),
                                                          uiOutput(ns("dm_danger_btn")),
                                                          uiOutput(ns("dm_danger_zone"))))))),

      # -- Raw table
      tabPanel(title = "Raw table",

               # -- Hide the whole panel if no data model
               conditionalPanel(condition ="output.hasDataModel == true", ns = ns,

                                wellPanel(h3(paste("Name: ", id)),

                                          fluidRow(column(width = 2,
                                                          p("Actions"),
                                                          uiOutput(ns("dm_sort_buttons"))),

                                                   column(width = 10,
                                                          p("Raw Table"),
                                                          DT::DTOutput(ns("raw_item_table"))))))),

      # --View table
      tabPanel(title = "View",

               # -- Hide the whole panel if no data model
               conditionalPanel(condition ="output.hasDataModel == true", ns = ns,

                                wellPanel(h3(paste("Name: ", id)),

                                          fluidRow(column(width = 2,
                                                          p("Actions"),
                                                          uiOutput(ns("adm_filter_buttons")),
                                                          p("Column name mask applied by default:",br(),
                                                            "- replace dot, underscore with space",br(),
                                                            "- capitalize first letters")),

                                                   column(width = 10,
                                                          p("Filtered Table"),
                                                          DT::DTOutput(ns("view_item_table")))))))))

}