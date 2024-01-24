

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
              column(width = 8,

                     h1("Home"),
                     p("This application demonstrates how to implement kitems module.", br(), "It includes two instances of the module:"),
                     tags$ul(

                       # -- data
                       tags$li("data"),
                       br(),
                       p("This instance is started with data.model = NULL.", br(), "As no data model is provided, the administration console will only
                         display the Create and Import data buttons."),
                       tags$pre("# -- start module server: data \nkitems::kitemsManager_Server(\nid = \"data\", \nr = r, \npath = path_list, \nfile = \"my_data.csv\", \ndata.model = NULL, \ncreate = TRUE, \nautosave = TRUE)"),

                       # -- data_2
                       tags$li("data_2"),
                       br(),
                       p("This instance is started with a data.model (output of kitems::data_model() function)", br(),
                         "Administration console shows data model, the raw table, and the default view.", br(),
                         "Also a sample data is provided with the demo app, so it can be displayed.")

                     )
              )),

            fluidRow(

              column(width = 8,
                     h3("Data_2"),
                     tags$ul(
                       tags$li("The date sliderInput (because data model has an attribute \'date\'):"), br(),
                       kitems::date_slider_INPUT("data_2"),

                       tags$li("The action buttons (depending on selection):"), br(),
                       kitems::create_BTN("data_2"),
                       kitems::update_BTN("data_2"),
                       kitems::delete_BTN("data_2"),
                       p(""),

                       tags$li("The filetered data table view:"), br(),
                       kitems::items_filtered_view_DT("data_2")

                       )))


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

