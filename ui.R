

# --------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny web application
# --------------------------------------------------------------------------------

# -- Library
library(shiny)
library(shinydashboard)
library(DT)


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

            # -- Admin
            fluidRow(
              column(width = 12,

                     admin_ui("data")))),


    # -- tabItem
    tabItem(tabName = "try",

            # -- Admin
            fluidRow(
              column(width = 12,

                     admin_ui("data_2"))),

            fluidRow(
              column(width = 12,

                     new_item_BTN("data_2"))
            ))


  ) # end tabItems
) # end dashboardBody


# --------------------------------------------------------------------------------
# Put them together into a dashboard
# --------------------------------------------------------------------------------

dashboardPage(

  dashboardHeader(title = "kitems Demo App"),
  sidebar,
  body

)
