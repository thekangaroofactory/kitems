

#' Data model admin UI
#'
#' @param id the module id
#'
#' @return a tagList() object to admin the data model
#' @export
#'
#' @examples
#' admin_ui(id = "mydata")

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
                         uiOutput(ns("admin_dm_tab")))),

      # -- Raw table
      tabPanel(title = "Raw table",

               wellPanel(h3(paste("Name: ", id)),
                         uiOutput(ns("admin_raw_tab")))),

      # --View table
      tabPanel(title = "View",

               wellPanel(h3(paste("Name: ", id)),
                         uiOutput(ns("admin_view_tab"))))))

}
