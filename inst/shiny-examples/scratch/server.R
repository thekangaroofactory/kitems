

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


    # -- log
    catl("----------------------------------------------------------", debug = 1)
    catl("Main application server ready", debug = 1)
    catl("----------------------------------------------------------", debug = 1)


    # -- Observe item list ----
    observeEvent(data_1$items(),
      catl("Main app server: data_1 items have just been updated."))


  }
)
