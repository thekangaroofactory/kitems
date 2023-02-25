
library(shiny)


# -- Declare path
path <- list(project = "./",
             script = "./R",
             resource = "./resource",
             data = "./data")


# -- Source scripts
cat("Source code from:", path$script, " \n")
for (nm in list.files(path$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)



shinyServer(function(input, output, session) {


  # Create the object with no values
  r <- reactiveValues()


  # -- start module server
  kitemsManager_Server("data", r, path, file = "my_data.csv", col.classes = NULL)


  # -- check
  observeEvent(r$data_items(), {

    cat("Data has just been updated \n")

  })


})

