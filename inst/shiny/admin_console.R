

# ------------------------------------------------------------------------------
# This is the kitems Admin Shiny application
# ------------------------------------------------------------------------------

# -- Define UI
ui <- fluidPage(fluidRow(uiOutput("admin_console")),
                title = "Kitems Admin Console")


# -- Define server logic
server <- function(input, output, session) {

  # -- get path
  path <- Sys.getenv("R_KITEMS_PATH")
  stopifnot("path is empty, set R_KITEMS_PATH environment variable" = path == "")

  # -- check folder(s)
  # each folder contains files related to an item and is named after the id
  items <- list.dirs(path, full.names = F, recursive = F)

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
    res <- lapply(items, function(x) kitems::kitems(id = x,
                                                    autosave = TRUE,
                                                    admin = TRUE))

    # -- ui
    renderUI({

      # -- build tabPanels content
      panels <- lapply(items, function(x) tabPanel(x, kitems::admin_widget(x)))

      # -- build page & return
      do.call(navbarPage, c(panels,
                            id = "page",
                            title = "Kitems"))})


  } # check items

}


# -- Run the application
shinyApp(ui = ui, server = server)
