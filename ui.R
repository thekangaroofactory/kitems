
library(shiny)

source("~/Work/Packages/kitems/R/admin_ui.R")

shinyUI(
  fluidPage(

    admin_ui("data"),

    new_item_btn("data")

  ))
