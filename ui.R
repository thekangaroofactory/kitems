

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

# sidebar <- dashboardSidebar(
#   sidebarMenu(
#     menuItem("Template", tabName = "template", icon = icon("dashboard"), selected = TRUE),
#     menuItem("Try", tabName = "try", icon = icon("tasks"))),
#   collapsed = FALSE)

sidebar <- dashboardSidebar(

  # -- static section
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("dashboard"), selected = TRUE)),

  # -- add dynamic section
  sidebarMenu(id = "tabs", sidebarMenuOutput("menu")),

  collapsed = FALSE)


# --------------------------------------------------------------------------------
# Define Body UI
# --------------------------------------------------------------------------------

body <- dashboardBody(

  # -- tabItems
  tabItems(

    # -- tabItem
    tabItem(tabName = "home",

            # -- Admin
            fluidRow(
              column(width = 12,

                     h1("Home page"),
                     #h4("Default view:"),
                     #items_view_DT("data_2"),
                     h4("Filtered view:"),
                     date_slider_INPUT("data_2"))),

            fluidRow(
              column(width = 12,
                     create_BTN("data_2"),
                     update_BTN("data_2"),
                     delete_BTN("data_2"))),

            br(),

            fluidRow(
              column(width = 12,
                     items_filtered_view_DT("data_2")))
    ),

    # -- tabItem
    tabItem(tabName = "data",

            # -- Admin
            fluidRow(
              column(width = 12,

                     admin_ui("data")))),

    # -- tabItem
    tabItem(tabName = "data_2",

            # -- Admin
            fluidRow(
              column(width = 12,

                     admin_ui("data_2"))))


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
