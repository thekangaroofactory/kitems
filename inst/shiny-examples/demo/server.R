

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
    data <- kitems::kitems_server(id = "data", path = demo_dir,
                                  create = TRUE, autosave = FALSE)


    # -- start module server: data_2
    # autosave = FALSE to keep demo data frozen
    data_2 <- kitems::kitems_server(id = "data_2", path = demo_dir,
                                    create = TRUE, autosave = FALSE)


    # --------------------------------------------------------------------------
    # Nested module implementation
    # --------------------------------------------------------------------------

    # -- define module server
    # Note: it should be in a different file, but that function would need to be
    # exported from the package to work with the demo.
    nested_Server <- function(id, demo_dir) {

      moduleServer(id, function(input, output, session) {

        # -- Note: this modules demonstrate how to implement kitems server
        # as a nested module.

        # -- start module server: data_3
        # autosave = FALSE to keep demo data frozen
        data_3 <- kitems::kitems_server(id = "data_3", path = demo_dir,
                                        create = TRUE, autosave = FALSE)

      })
    }

    # -- call shiny module (nested module implementation)
    data_3 <- nested_Server(id = "wrapper", demo_dir)


    # -- log
    cat("----------------------------------------------------------\n")
    cat("Main application server ready\n")
    cat("----------------------------------------------------------\n")


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
    output$menu <- renderMenu(kitems::dynamic_sidebar(names = list("data", "data_2", "data_3")))


  }
)
