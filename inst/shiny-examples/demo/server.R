

# ------------------------------------------------------------------------------
# This is the server logic of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Define server logic
shinyServer(
  function(input, output, session){


    # -- Get path to demo app data
    demo_dir <- system.file("shiny-examples", "demo", "data", package = "kitems")


    # -- Launch module servers ----
    # autosave = FALSE to keep demo data frozen
    data_2 <- kitems::kitems(id = "data_2", path = demo_dir,
                             autosave = FALSE, admin = FALSE,
                             shortcut = TRUE)


    # -- log
    catl("----------------------------------------------------------", debug = 1)
    catl("Main application server ready", debug = 1)
    catl("----------------------------------------------------------", debug = 1)


    # -- Observe item lists ----
    observeEvent(data_2$items(),
      catl("Main application server: data_2 items have just been updated"))


  }
)
