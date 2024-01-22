

# ------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny web application
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Define Sidebar UI
# ------------------------------------------------------------------------------

sidebar <- shinydashboard::dashboardSidebar(

  # -- static section
  shinydashboard::sidebarMenu(
    shinydashboard::menuItem("Home", tabName = "home", icon = icon("dashboard"), selected = TRUE)),

  # -- add dynamic section
  shinydashboard::sidebarMenu(id = "tabs", shinydashboard::sidebarMenuOutput("menu")),

  collapsed = FALSE)


# ------------------------------------------------------------------------------
# Define Body UI
# ------------------------------------------------------------------------------

body <- shinydashboard::dashboardBody(

  # -- tabItems
  shinydashboard::tabItems(

    # -- tabItem
    shinydashboard::tabItem(tabName = "home",

            # -- Admin
            shiny::fluidRow(
              shiny::column(width = 12,

                            shiny::h1("Home page"),
                            shiny::h4("Filtered view:"),
                            kitems::date_slider_INPUT("data_2"))),

            shiny::fluidRow(
              shiny::column(width = 12,
                            kitems::create_BTN("data_2"),
                            kitems::update_BTN("data_2"),
                            kitems::delete_BTN("data_2"))),

            shiny::br(),

            shiny::fluidRow(
              shiny::column(width = 12,
                            kitems::items_filtered_view_DT("data_2")))
    ),

    # -- tabItem
    shinydashboard::tabItem(tabName = "data",

            # -- Admin
            shiny::fluidRow(
              shiny::column(width = 12,

                            kitems::admin_ui("data")))),

    # -- tabItem
    shinydashboard::tabItem(tabName = "data_2",

            # -- Admin
            shiny::fluidRow(
              shiny::column(width = 12,

                            kitems::admin_ui("data_2"))))


  ) # end tabItems
) # end dashboardBody


# ------------------------------------------------------------------------------
# Put them together into a dashboard
# ------------------------------------------------------------------------------

shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title = "kitems Demo App"), sidebar, body)

