

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
    menuItem("Home", tabName = "home", icon = icon("dashboard"), selected = TRUE)),

  # -- add dynamic section
  # see server.R
  sidebarMenu(id = "tabs", sidebarMenuOutput("menu")),

  collapsed = FALSE)


# -- Define Body UI ----
body <- dashboardBody(

  # -- Container
  tabItems(

    # -- Content tab
    tabItem(tabName = "home",
            fluidRow(
              column(width = 8,

                     h1("Introduction"),
                     p("This application demonstrates how to implement kitems module as a nested module."),

                     h3("Data"),
                     p("This instance has no corresponding files (data model or items) in the path.", br(),
                       "The administration console will only display the Create and Import data buttons."),

                     tags$pre("# -- start module server: \ndata_3 <- kitems::kitems(id = \"data_3\",
                              path = \"path/to/my/data\", \ncreate = TRUE, autosave = FALSE, admin = TRUE)"),

                     p("For details about the nested module implementation, see the server code.
                       If the data need to be available at the main server level, then the wrapper module
                       should return the output of the kitems module server."),

                     p("Because autosave is FALSE (to keep demo app in frozen state), nothing will be saved if
                       data are created or imported."),

                     # -- admin
                     h3("Admin console"),

                     p("In general, it is not recommended to display the admin console within the
                        application as any user could alter the data model.", br(),
                       "It is implemented here for the purpose of the demonstation."),

                     p("A menu output is generated on server side using renderMenu function,
                        which is used by a sidebarMenuOutput function on ui side."),

                     p("Because it is called with an id that includes the wrapper module namespace,
                       the admin console will display a message in the name field.
                       The other way to implement it is to wrap the admin console ui into a specific ui
                       function in the wrapper module and call it from the main app ui.")))),

    # -- Content tab
    tabItem(tabName = "data_3",

            # -- Admin
            fluidRow(
              column(width = 12,

                     kitems::admin_widget("wrapper-data_3"))))


  ) # end tabItems
) # end dashboardBody


# -- Put them together into a dashboard ----
dashboardPage(
  dashboardHeader(title = "kitems Demo App"), sidebar, body)

