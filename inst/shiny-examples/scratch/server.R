

# ------------------------------------------------------------------------------
# This is the server logic of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Define server logic
shinyServer(
  function(input, output, session){

    # -- Get path to demo app ----
    demo_dir <- system.file("shiny-examples", "scratch", package = "kitems")


    # -- Launch module server ----
    # autosave = FALSE to keep demo data frozen
    # admin = TRUE to showcase sidebar
    data_1 <- kitems::kitems(id = "data_1", path = demo_dir,
                             autosave = FALSE, admin = TRUE)


    # -- Generate dynamic sidebar ----
    # see ui.R
    output$menu <- renderMenu(kitems::dynamic_sidebar(names = list("data_1")))

  }
)
