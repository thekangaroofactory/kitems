

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
    data_2 <- kitems::kitems_server(id = "data_2", path = demo_dir,
                                    create = TRUE, autosave = FALSE, admin = FALSE,
                                    shortcut = TRUE)


    # -- log
    cat("----------------------------------------------------------\n")
    cat("Main application server ready\n")
    cat("----------------------------------------------------------\n")


    # -- Observe item lists ----
    observeEvent(data_2$items(),
      cat("Main application server: data_2 items have just been updated \n"))


  }
)
