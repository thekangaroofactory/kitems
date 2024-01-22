

# --------------------------------------------------------------------------------
# This is the server logic of the Shiny web application
# --------------------------------------------------------------------------------

# -- Load packages
library(shiny)


# -- Define server logic
shinyServer(
  function(input, output, session){


    # -------------------------------------
    # Communication objects
    # -------------------------------------

    # -- declare r communication object
    r <- reactiveValues()


    # -------------------------------------
    # Launch module servers
    # -------------------------------------

    # -- start module server: data
    kitemsManager_Server(id = "data", r = r, path = path_list, file = "my_data.csv",
                         data.model = NULL,
                         create = TRUE, autosave = TRUE)


    # -- setup default values/functions:
    colClasses <- c("id" = "double", "name" = "character", "total" = "numeric")
    default.val <- c("name" = "test", "total" = 2)
    default.fun <- c("id" = "ktools::getTimestamp")
    filter <- c("id")
    skip <- c("id")

    # -- build data model
    dm <- data_model(colClasses, default.val, default.fun, filter, skip)

    # -- start module server: data_2
    kitemsManager_Server(id = "data_2", r = r, path = path_list, file = "my_data_2.csv",
                         data.model = dm,
                         create = TRUE, autosave = TRUE)


    # -------------------------------------
    # Observe item lists
    # -------------------------------------

    # -- data
    observeEvent(r$data_items(), {

      cat("Main server observer: data_items() has just been updated \n")

    })

    # -- data_2
    observeEvent(r$data_2_items(), {

      cat("Main server observer: data2_items() has just been updated \n")

    })


    # -------------------------------------
    # Generate dynamic sidebar
    # -------------------------------------

    output$menu <- renderMenu(dynamic_sidebar(r))


    # -------------------------------------
    # SAND BOX
    # -------------------------------------

    # id <- "data_2"
    #
    # r_data_model <- dm_name(id)
    # trigger_delete <- trigger_delete_name(id)
    #
    # observeEvent(r$data_2_items(), {
    #
    #   cat("*** SAND BOX: delete item \n")
    #
    #   item <- 1704961867683
    #   r[[trigger_delete]](item)
    #
    # })

  }
)

