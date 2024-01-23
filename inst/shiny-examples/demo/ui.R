

# ------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny web application
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Define Sidebar UI
# ------------------------------------------------------------------------------

sidebar <- dashboardSidebar(

  # -- static section
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("dashboard"), selected = TRUE)),

  # -- add dynamic section
  sidebarMenu(id = "tabs", sidebarMenuOutput("menu")),

  collapsed = FALSE)


# ------------------------------------------------------------------------------
# Define Body UI
# ------------------------------------------------------------------------------

body <- dashboardBody(

  # -- tabItems
  tabItems(

    # -- tabItem
    tabItem(tabName = "home",

            # -- Admin
            fluidRow(
              column(width = 12,

                     h1("Home page"),
                     h4("Filtered view:"),
                     kitems::date_slider_INPUT("data_2"))),

            fluidRow(
              column(width = 12,
                     kitems::create_BTN("data_2"),
                     kitems::update_BTN("data_2"),
                     kitems::delete_BTN("data_2"))),

            br(),

            fluidRow(
              column(width = 12,
                     kitems::items_filtered_view_DT("data_2")))
    ),

    # -- tabItem
    tabItem(tabName = "data",

            # -- Admin
            fluidRow(
              column(width = 12,

                     kitems::admin_ui("data")))),

    # -- tabItem
    tabItem(tabName = "data_2",

            # -- Admin
            fluidRow(
              column(width = 12,

                     kitems::admin_ui("data_2"))))


  ) # end tabItems
) # end dashboardBody


# ------------------------------------------------------------------------------
# Put them together into a dashboard
# ------------------------------------------------------------------------------

dashboardPage(
  dashboardHeader(title = "kitems Demo App"), sidebar, body)

