

# ------------------------------------------------------------------------------
# This is the server logic of the Shiny web application
# ------------------------------------------------------------------------------

# -- Define server logic
shinyServer(
  function(input, output, session){


    # -------------------------------------
    # Environment
    # -------------------------------------

    # -- Get path to demo app data
    demo_dir <- system.file("shiny-examples", "demo", "data", package = "kitems")

    # -- declare r communication object
    r <- reactiveValues()


    # -------------------------------------
    # Launch module servers
    # -------------------------------------

    # -- start module server: data
    data <- kitems::kitemsManager_Server(id = "data", r = r, path = demo_dir,
                                         create = TRUE, autosave = FALSE)


    # -- start module server: data_2
    data_2 <- kitems::kitemsManager_Server(id = "data_2", r = r, path = demo_dir,
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

    # -- adding pkg::fun() call #205
    output$menu <- renderMenu(kitems::dynamic_sidebar(names = list("data", "data_2")))


  }
)

