

# ------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Check: when runExample is called from kitems::runExample() without attaching kitems #204
if(!"shinydashboard" %in% (.packages()))
  library(shinydashboard)


# -- Define Sidebar UI ----
sidebar <- dashboardSidebar(collapsed = FALSE,
                            sidebarMenu(
                              menuItem("Home", tabName = "home", icon = icon("dashboard"), selected = TRUE)))


# -- Define Body UI ----
body <- dashboardBody(

  # -- Container
  tabItems(

    # -- Content tab
    tabItem(tabName = "home",

            # -- Intro
            fluidRow(
              column(width = 8,

                     h1("Introduction"),
                     p("This application demonstrates how to implement kitems module."),

                     h3("Data"),
                     p("This instance is started with a path that contains a data model (output of data_model function) file", br(),
                       "as well as a sample items file, so it can be displayed in the section below."),

                     # -- warning
                     fluidRow(
                       box(title = "Autosave is set to FALSE",
                           width = 12,
                           solidHeader = TRUE,
                           status = "info",
                           "Create / update / delete won't be persistent (the save function is never called)")),

                     h3("Admin console"),
                     p("Administration console in not implemented in the ui or server (admin = FALSE).", br(),
                       "To access it, run the admin() function"),
                     tags$pre("# -- start admin console: \nadmin(system.file(\"shiny-examples\", \"demo\", \"data\", package = \"kitems\"))"))),


            # -- data_2
            fluidRow(
              column(width = 8,

                     h1("Components"),

                     h3("Date sliderInput"),
                     p("The date sliderInput UI component is available whenever the data model has an attribute named \'date\'", br(),
                       tags$pre("# -- Date filter: \ndate_slider_INPUT(id)"),
                       "It is initialized with the values from the items table (see below)", br(),
                       "Selected range will be applied on the filtered data table (see filtered view below)."),

                     wellPanel(
                       fluidRow(column(width = 1),
                                column(width = 11,
                                       kitems::date_slider_INPUT("data_2")))),

                     p("Strategies:"),
                     tags$ul(
                       tags$li("this-year: default range will be limited to dates belonging to the current year.", br(),
                               "when an item is added, selection will be extended to include the new date if it fits with current year."),
                       tags$li("keep-range: the range will stick to what user has previously selected.")),


                     h3("Action buttons"),

                     p("Create, update and delete item action buttons are provided."),
                     p("Their UI functions will either return a button or NULL:"),
                     tags$ul(
                       tags$li("create will be NULL if the data model is empty"),
                       tags$li("update & delete will be NULL if no row is selected in the filtered table")),

                     kitems::create_BTN("data_2"),
                     kitems::update_BTN("data_2"),
                     kitems::delete_BTN("data_2"),
                     p(""),


                     h3("Items table"),

                     p("A filtered item view is available."),
                     tags$pre("# -- Filtered view: \nfiltered_view_ui(id)"),

                     fluidRow(column(width = 12,
                                     wellPanel(
                                       kitems::filtered_view_ui("data_2"))))))),

    # -- Content tab
    tabItem(tabName = "data_2",

            # -- Admin
            fluidRow(
              column(width = 12,

                     kitems::admin_ui("data_2"))))


  ) # end tabItems
) # end dashboardBody


# -- Put them together into a dashboard ----
dashboardPage(
  dashboardHeader(title = "kitems Demo App"), sidebar, body)

