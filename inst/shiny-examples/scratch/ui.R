

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
                     p("This application demonstrates how to implement {kitems} module from scracth (no data)."),

                     h3("Data"),
                     p("This instance has no corresponding files (data model or items) in the given path.", br(),
                       "The administration console will only display the Create and Import data buttons."),
                     tags$pre("# -- start module server: \ndata_1 <- kitems::kitems(id = \"data_1\",
                              path = \"path/to/my/data\",
                              autosave = FALSE,
                              admin = TRUE)"),
                     p("Because autosave is FALSE (to keep this demo in frozen state), nothing will be saved if
                       data are created or imported."),

                     # -- admin
                     h3("Admin console"),
                     p("In general, it is not recommended to display the admin console within the
                               application as any user could alter the data model.", br(),
                       "It is implemented here for the purpose of the demonstation."),
                     p("A menu output is generated on server side using renderMenu function,
                                 which is used by a sidebarMenuOutput function on ui side.")))),

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

