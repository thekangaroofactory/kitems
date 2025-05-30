

# ------------------------------------------------------------------------------
# This is the server logic of the Shiny demo application
# ------------------------------------------------------------------------------

# -- Define server logic
shinyServer(
  function(input, output, session){


    # -- Get path to demo app data
    demo_dir <- system.file("shiny-examples", "nested", package = "kitems")


    # -- Nested module implementation ----

    # -- define module server
    # Note: it should be in a different file, but that function would need to be
    # exported from the package to work with the demo.
    wrapper_server <- function(id, demo_dir) {

      moduleServer(id, function(input, output, session) {

        # -- start kitems module server: data_3
        # autosave = FALSE to keep demo data frozen
        data_3 <- kitems::kitems(id = "data_3", path = demo_dir,
                                 autosave = FALSE, admin = TRUE)

      })
    }

    # -- call the wrapper module
    # make sure it returns the output of kitems
    data_3 <- wrapper_server(id = "wrapper", demo_dir)

    # -- Generate dynamic sidebar ----
    output$menu <- renderMenu(kitems::dynamic_sidebar(names = list("data_3")))


    # -- log
    ktools::catl("----------------------------------------------------------", debug = 1)
    ktools::catl("Main application server ready", debug = 1)
    ktools::catl("----------------------------------------------------------", debug = 1)


    # -- Observe item lists ----
    observeEvent(data_3$items(),
                 ktools::catl("Main application server: data_3 items have just been updated"))


  }
)
