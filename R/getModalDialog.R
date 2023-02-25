

getModalDialog <- function(item = NULL, update = FALSE, colClasses){

  # helper function
  add_input <- function(x, colClasses){

    cat("Dealing with attribute #", x, "\n")

    if(colClasses[[x]] == "numeric") print("")

    # numeric, integer, double
    numericInput(
      inputId,
      label,
      value,
      min = NA,
      max = NA,
      step = NA,
      width = NULL)

    # date, POSIXct
    dateInput(
      inputId,
      label,
      value = NULL,
      min = NULL,
      max = NULL,
      format = "yyyy-mm-dd",
      startview = "month",
      weekstart = 0,
      language = "en",
      width = NULL,
      autoclose = TRUE,
      datesdisabled = NULL,
      daysofweekdisabled = NULL)

    # character
    textInput(inputId, label, value = "", width = NULL, placeholder = NULL)

    # logical
    checkboxInput(inputId, label, value = FALSE, width = NULL)

  }

  # skip attribute id (auto)
  colClasses <- colClasses[!names(colClasses) %in% "id"]

  # apply helper
  lapply(1:length(colClasses), function(x) add_input(x, colClasses))

}
