

# --------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny web application
# --------------------------------------------------------------------------------

# -- Library
library(shiny)
library(shinydashboard)
library(DT)


# -- init env
source("./environment.R")
#source("./config.R")


# -- source scripts
cat("Source code from:", path_list$script, " \n")
for (nm in list.files(path_list$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)


# --------------------------------------------------------------------------------
# Define Sidebar UI
# --------------------------------------------------------------------------------

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Template", tabName = "template", icon = icon("dashboard"), selected = TRUE),
    menuItem("Try", tabName = "try", icon = icon("tasks"))),
  collapsed = FALSE)


# --------------------------------------------------------------------------------
# Define Body UI
# --------------------------------------------------------------------------------

body <- dashboardBody(

  # -- tabItems
  tabItems(

    # -- tabItem
    tabItem(tabName = "template",

            # -- something
            fluidRow(
              column(width = 12,

                     admin_ui("data")))),


    # -- tabItem
    tabItem(tabName = "try",

            # -- something
            fluidRow(
              column(width = 12,

                     admin_ui("data_2"))))


  ) # end tabItems
) # end dashboardBody


# --------------------------------------------------------------------------------
# Put them together into a dashboard
# --------------------------------------------------------------------------------
#
dashboardPage(

  dashboardHeader(title = "kitems Demo App"),
  sidebar,
  body

)
