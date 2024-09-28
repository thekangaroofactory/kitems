

# ------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Check: when runExample is called from kitems::runExample() without attaching kitems #204
if(!"shinydashboard" %in% (.packages()))
  library(shinydashboard)


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

  # -- Container
  tabItems(

    # -- Content tab
    tabItem(tabName = "home",

            # -- Admin
            fluidRow(
              column(width = 8,

                     h1("Introduction"),
                     p("This application demonstrates how to implement kitems module.", br(), "It includes two instances of the module:"),

                     tags$ul(

                       # -- data
                       tags$li("data"),
                       br(),
                       p("This instance has no corresponding files (data model or items) in the provided path.", br(),
                       "As no data model is provided, the administration console will only display the Create and Import data buttons."),
                       tags$pre("# -- start module server: \ndata <- kitems::kitemsManager_Server(id = \"data\", path = \"path/to/my/data\", \ncreate = TRUE, autosave = FALSE)"),

                       # -- data_2
                       tags$li("data_2"),
                       br(),
                       p("This instance is started with a data model (output of kitems::data_model() function)", br(),
                         "Administration console shows data model, the raw table, and the default view.", br(),
                         "Also a sample data is provided with the demo app, so it can be displayed.", br(), br(),

                         box(title = "Autosave is set to FALSE",
                             width = 6,
                             solidHeader = TRUE,
                             status = "info",
                             "Create / update / delete won't be persistent (the save function is never called)"),

                         )))),

            # -- data_2
            fluidRow(
              column(width = 8,

                     h1("Components"),

                     h3("Date sliderInput"),
                     p("The date sliderInput UI component is available whenever the data model has an attribute named \'date\'", br(),
                       tags$pre("# -- Date filter: \ndate_slider_INPUT(id)"),
                       "It is initialized with the values from the items table (see below)", br(),
                       "Selected range will be applied on the filtered data table."),

                     wellPanel(
                       fluidRow(column(width = 1),
                                column(width = 11,
                         kitems::date_slider_INPUT("data_2")))),

                     p("Strategies:"),
                     tags$ul(
                       tags$li("this-year: default range will be limited to dates belonging to current year.", br(),
                               "when an item is added, selection will be extended to include that new date"),
                       tags$li("keep-range: the range will stick to what user has previously selected.")),


                     h3("Action buttons"),

                     p("Create / update / delete item action buttons are provided", br(),
                       "their UI functions will return a button or NULL depending on selection in the items table:"),

                     kitems::create_BTN("data_2"),
                     kitems::update_BTN("data_2"),
                     kitems::delete_BTN("data_2"),
                     p(""),


                     h3("Items table"),

                     p("Two views are delivered: standard and filtered."),
                     tags$pre("# -- Standard view: \nitems_view_DT(id) \n\n# -- Filtered view: \nitems_filtered_view_DT(id)"),

                     box(title = "Note",
                         width = 6,
                         solidHeader = TRUE,
                         status = "info",
                         "It is assumed that only one item table view will be used at a time \n",
                         "This is because buttons fires actions on the last selected items - i.e. no matter in which table."),

                     fluidRow(column(width = 12,
                                     wellPanel(
                                       kitems::items_filtered_view_DT("data_2"))))))),

    # -- Content tab
    tabItem(tabName = "data",

            # -- Admin
            fluidRow(
              column(width = 12,

                     kitems::admin_ui("data")))),

    # -- Content tab
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

