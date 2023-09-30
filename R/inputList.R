

#' Title
#'
#' @param ns
#' @param item
#' @param update
#' @param colClasses
#' @param skip
#'
#' @return
#' @export
#'
#' @examples

inputList <- function(ns, item = NULL, update = FALSE, colClasses, skip = NULL){

  cat("[getModalDialog] Building modal dialog \n")

  # -- helper function
  add_input <- function(x, colClasses){

    cat("  - Dealing with attribute", x, "type =", colClasses[[x]], "\n")

    # -- character
    if(colClasses[[x]] == "character")
      input <- textInput(inputId = ns(names(colClasses[x])),
                         label = names(colClasses[x]),
                         value = "character",
                         width = NULL,
                         placeholder = NULL)

    # -- numeric, integer, double
    if(colClasses[[x]] %in% c("numeric", "integer", "double"))
      input <- numericInput(
        inputId = ns(names(colClasses[x])),
        label = "num",
        value = 0,
        min = NA,
        max = NA,
        step = NA,
        width = NULL)

    # -- date, POSIXct
    if(colClasses[[x]] %in% c("Date", "POSIXct", "POSIXlt"))
      input <- dateInput(
        inputId = ns(names(colClasses[x])),
        label = "Date",
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

    # -- logical
    if(colClasses[[x]] == "logical")
      input <- checkboxInput(inputId = ns(names(colClasses[x])),
                             label = "logical",
                             value = FALSE,
                             width = NULL)

    # -- return
    input

  }

  # -- Filter out attributes in skip param
  cat("  - Filter out attributes to skip:", skip, "\n")
  colClasses <- colClasses[!names(colClasses) %in% skip]

  # -- apply helper
  feedback <- lapply(1:length(colClasses), function(x) add_input(x, colClasses))

  # -- output
  tagList(feedback)

}
