

# ------------------------------------------------------------------------------
# This is the kitems Admin Shiny application
# ------------------------------------------------------------------------------

# -- Define UI
ui <- fluidPage(fluidRow(uiOutput("admin_console")),
                title = "Kitems Admin Console")


# -- Define server logic
server <- function(input, output, session) {

  # -- get the path from option
  kitems_path <- getwd()
  kitems_path <- getShinyOption("kitems_path", kitems_path)

  # -- check folder(s) in kitems_path
  # each folder contains files related to an item and is named after the id
  items <- list.dirs(kitems_path, full.names = F, recursive = F)

  # -- check items
  output$admin_console <- if(length(items) == 0)

    # -- ui: display message
    renderUI(
      column(width = 12,
             h3("Kitems Admin Console"),
             p(id = "subtitle", em("Manage your items data model")),
             wellPanel("No item has been found in the provided path.")))

  else {

    # -- launch item servers
    res <- lapply(items, function(x) kitems(id = x,
                                                   path = kitems_path,
                                                   create = FALSE,
                                                   autosave = TRUE,
                                                   admin = TRUE))

    # -- ui
    renderUI({

      # -- build tabPanels content
      panels <- lapply(items, function(x) tabPanel(x, kitems::admin_ui(x)))

      # -- build page & return
      do.call(navbarPage, c(panels,
                            id = "page",
                            title = "Kitems"))})


  } # check items

}


# -- Run the application
shinyApp(ui = ui, server = server)
