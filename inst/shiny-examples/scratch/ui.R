

# ------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Check: when runExample is called from kitems::runExample() without attaching kitems #204
if(!"shinydashboard" %in% (.packages()))
  library(shinydashboard)


# -- Define Sidebar UI ----
sidebar <- dashboardSidebar(

  # -- static section
  sidebarMenu(
    menuItem("Introduction", tabName = "intro", icon = icon("house"), selected = TRUE),
    menuItem("Items", tabName = "items", icon = icon("rectangle-list"))),

  # -- add dynamic section
  # see server.R
  sidebarMenu(id = "tabs", sidebarMenuOutput("menu")),

  collapsed = FALSE)


# -- Define Body UI ----
body <- dashboardBody(

  # -- Container
  tabItems(

    # -- Content tab
    tabItem(tabName = "intro",
            fluidRow(
              column(width = 8,

                     h1("Kitems from scratch"),

                     p("This application demonstrates the behavior of the {kitems} module when",
                       "it is used from scracth (no item or data model).", br(),
                       "It's possible to use it as a playground: you can create a data model and",
                       "see how it affects the 'items' tab."),

                     h2("Data"),
                     p("This instance has no corresponding files (data model or items) in the given path.", br(),
                       "The administration console will only display the 'create' and 'import' buttons."),
                     tags$pre("# -- start module server: \ndata_1 <- kitems::kitems(id = \"data_1\",
                              path = \"path/to/my/data\",
                              autosave = FALSE,
                              admin = TRUE)"),
                     # -- warning
                     fluidRow(
                       box(title = "Autosave",
                           width = 12,
                           solidHeader = TRUE,
                           status = "warning",
                           collapsible = TRUE,
                           "The autosave argument of the module server function is set to FALSE for demonstration purpose.", br(),
                           "Creating a data model or items won't be persistent after the app is closed.")),

                     # -- admin
                     h3("Admin console"),
                     p("In general, it is not recommended to display the admin console within the
                               application as any user could alter the data model!", br(),
                       "It is implemented here for the purpose of the demonstation.")))),

    # -- Content tab
    tabItem(tabName = "items",

            # -- inputs
            fluidRow(

              column(width = 6,
                     h2("Buttons"),
                     p("Buttons are not visible when there is no data model defined."),
                     kitems::create_widget("data_1"),
                     kitems::update_widget("data_1"),
                     kitems::delete_widget("data_1")),

              column(width = 6,
                     h2("Filter"),
                     p("The date filter is not visible when there is no item."),
                     kitems::date_slider_widget("data_1"))),

            # -- items
            fluidRow(
              column(width = 12,
                     h2("Items"),
                     p("A message is displayed when the table is empty:"),
                     kitems::filtered_view_widget("data_1")))),

    # -- Content tab
    tabItem(tabName = "data_1",

            # -- Admin
            fluidRow(
              column(width = 12,

                     kitems::admin_widget("data_1"))))


  ) # end tabItems
) # end dashboardBody


# ------------------------------------------------------------------------------
# Put them together into a dashboard
# ------------------------------------------------------------------------------

dashboardPage(
  dashboardHeader(title = "kitems Demo App"), sidebar, body)

