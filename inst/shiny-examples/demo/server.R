

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
    data_2 <- kitems::kitems(id = "data_2",
                             path = demo_dir,
                             autosave = FALSE,
                             admin = FALSE,
                             options = list(shortcut = TRUE))

  }
)
