

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
    ktools::catl("----------------------------------------------------------", debug = 1)
    ktools::catl("Main application server ready", debug = 1)
    ktools::catl("----------------------------------------------------------", debug = 1)


    # -- Observe item lists ----
    observeEvent(data_2$items(),
                 ktools::catl("Main application server: data_2 items have just been updated"))


  }
)
