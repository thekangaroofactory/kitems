

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

    # -- start module server: data
    kitemsManager_Server(id = "data", r = r, path = path_list, file = "my_data.csv",
                         col.classes = NA, default.val = NULL, default.fun = NULL, filter.cols = NULL,
                         create = TRUE, autosave = TRUE)


    # -- setup default values/functions:
    default.val <- c("name" = "test", "total" = 2)
    default.fun <- c("id" = "ktools::getTimestamp")


    # -- start module server: data_2
    kitemsManager_Server(id = "data_2", r = r, path = path_list, file = "my_data_2.csv",
                         col.classes = NA, default.val = default.val, default.fun = default.fun, filter.cols = NULL,
                         create = TRUE, autosave = TRUE)


    # -------------------------------------
    # -- check
    observeEvent(r$data_items(), {

      cat("Main server observer: data_items() has just been updated \n")

    })

    observeEvent(r$data_2_items(), {

      cat("Main server observer: data2_items() has just been updated \n")

    })

  }
)

