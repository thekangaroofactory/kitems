

# --------------------------------------------------------------------------------
# This is the server logic of the Shiny web application
# --------------------------------------------------------------------------------

# -- Library
library(shiny)
library(DT)


# -- init env
source("./environment.R")
#source("./config.R")


# -- Source scripts
cat("Source code from:", path_list$script, " \n")
for (nm in list.files(path_list$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)


# -- Define server logic
shinyServer(
  function(input, output, session){

    # *******************************************************************************************************
    # DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
    # *******************************************************************************************************

    DEBUG <<- TRUE

    if(DEBUG){

      cat("Source code from:", path_list$script, " \n")
      for (nm in list.files(path_list$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
      {
        source(nm, encoding = 'UTF-8')
      }
      rm(nm)

    }

    # *******************************************************************************************************
    # DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
    # *******************************************************************************************************

    # -------------------------------------
    # Communication objects
    # -------------------------------------

    # -- declare r communication object
    r <- reactiveValues()


    # -------------------------------------
    # Launch module servers
    # -------------------------------------

    # -- start module server
    kitemsManager_Server(id = "data", r = r, path = path_list, file = "my_data.csv", col.classes = NA, create = TRUE, autosave = TRUE)
    kitemsManager_Server(id = "data_2", r = r, path = path_list, file = "my_data_2.csv", col.classes = NA, create = TRUE, autosave = TRUE)


    # -------------------------------------
    # -- check
    observeEvent(r$data_items(), {

      cat("Main server observer: data has just been updated \n")

    })

  }
)

