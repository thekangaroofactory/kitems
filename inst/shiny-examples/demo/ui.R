

# ------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Check: when runExample is called from kitems::runExample() without attaching kitems #204
if(!"shinydashboard" %in% (.packages()))
  library(shinydashboard)


# -- Define Sidebar UI ----
sidebar <- dashboardSidebar(collapsed = FALSE,
                            sidebarMenu(
                              menuItem("Introduction", tabName = "intro", icon = icon("dashboard"), selected = TRUE),
                              menuItem("Content", tabName = "content", icon = icon("dashboard"))))


# -- Define Body UI ----
body <- dashboardBody(

  # -- Container
  tabItems(

    # -- Content tab
    tabItem(tabName = "intro",

            # -- intro
            fluidRow(
              column(width = 8,

                     h1("Introduction"),
                     p("This application demonstrates how to implement {kitems} Shiny module."),

                     h2("Implementation"),
                     p("This demo is based on the 'Full delegation' implementation, in which the item management
                       is only performed in the kitems() module server (see vignette(\"implementation\"))."),

                     h2("Data"),
                     p("This instance is started with a path that contains a data model file", br(),
                       "as well as an item file with some content."),

                     # -- warning
                     fluidRow(
                       box(title = "Autosave is set to FALSE",
                           width = 12,
                           solidHeader = TRUE,
                           status = "info",
                           "The autosave argument of the module server function is set to FALSE for demonstration purpose.",
                           "Create / update / delete won't be persistent after the app is closed.")),

                     h3("Admin console"),
                     p("Administration console is a dedicated Shiny app.", br(),
                       "To access it, run the admin() function:"),
                     tags$pre("# -- start admin console \nadmin(system.file(\"shiny-examples\", \"demo\", \"data\", package = \"kitems\"))"))),


            ),

    # -- Content tab
    tabItem(tabName = "content",

            # -- components
            fluidRow(
              column(width = 6,

                     h1("Components"),

                     h2("Action buttons"),
                     p("Create, update and delete action buttons are provided.", br(),
                       "Their visibility is contextual to the item table selection."),

                     kitems::create_widget("data_2"),
                     kitems::update_widget("data_2"),
                     kitems::delete_widget("data_2"), p(),

                     tags$pre("# -- Create button: \ncreate_widget(id) \n# -- Update button: \nupdate_widget(id) \n# -- Dete button: \ndelete_widget(id)"),

                     h2("Date slider input"),
                     p("The date slider component is available whenever the data model has an attribute named \'date\' (strictly)", br(),
                       "It is initialized with the values from the items table.", br(),
                       "Selected range will be applied on the filtered view."),
                     p("The strategies are sescribed in the filtering documentation article."),

                     wellPanel(
                       fluidRow(column(width = 1),
                                column(width = 11,
                                       kitems::date_slider_widget("data_2")))),

                     tags$pre("# -- Date filter: \ndate_slider_widget(id)")),

              column(width = 6,

                     h2("Items table"),
                     p("A (filtered) item view is available."),

                     fluidRow(column(width = 12,
                                     wellPanel(
                                       kitems::filtered_view_widget("data_2")))),


                     tags$pre("# -- Filtered view: \nfiltered_view_widget(id)"),

                     h2("Server side"),
                     p("The server function of this demo app contains a single expression!"),

                     tags$pre("# -- launch kitems module server \ndata_2 <- kitems::kitems(id = \"data_2\", \npath = demo_dir, \nautosave = FALSE, \nadmin = FALSE, \noptions = list(shortcut = TRUE))")


                     )))


  ) # end tabItems
) # end dashboardBody


# -- Put them together into a dashboard ----
dashboardPage(
  dashboardHeader(title = "kitems Demo App"), sidebar, body)

