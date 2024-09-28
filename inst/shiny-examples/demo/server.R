

# ------------------------------------------------------------------------------
# This is the server logic of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Define server logic
shinyServer(
  function(input, output, session){

    # -------------------------------------
    # Environment
    # -------------------------------------

    # -- Get path to demo app data
    demo_dir <- system.file("shiny-examples", "demo", "data", package = "kitems")


    # -------------------------------------
    # Launch module servers
    # -------------------------------------

    # -- start module server: data
    # autosave = FALSE to keep demo data frozen
    data <- kitems::kitemsManager_Server(id = "data", path = demo_dir,
                                         create = TRUE, autosave = FALSE)


    # -- start module server: data_2
    # autosave = FALSE to keep demo data frozen
    data_2 <- kitems::kitemsManager_Server(id = "data_2", path = demo_dir,
                                           create = TRUE, autosave = FALSE)


    # -------------------------------------
    # Observe item lists
    # -------------------------------------

    # -- data
    observeEvent(data$items(), {

      cat("Main application server observeEvent: data_1() has just been updated \n")

    })

    # -- data_2
    observeEvent(data_2$items(), {

      cat("Main application server observeEvent: data_2() has just been updated \n")

    })


    # -------------------------------------
    # Generate dynamic sidebar
    # -------------------------------------

    # -- build menu from list of ids
    output$menu <- renderMenu(kitems::dynamic_sidebar(names = list("data", "data_2")))


  }
)
