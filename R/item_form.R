

#' Build item input tagList
#'
#' @param ns the namespace function, output of shiny::NS()
#' @param item an optional item (used to set default input values if update = TRUE)
#' @param update an optional logical (default = FALSE) to trigger update behavior
#' @param data.model a data.frame containing the data model
#'
#' @return a tagList() object containing the attribute inputs
#' @export
#'
#' @details
#' Data model skip feature will be used to return inputs only for the skip = FALSE attributes
#'
#' @examples
#' \dontrun{
#' item_form(ns, item = NULL, update = FALSE, data.model = mydatamodel)
#' item_form(ns, item = myitem, update = TRUE, data.model = mydatamodel)
#' }

item_form <- function(ns, item = NULL, update = FALSE, data.model){

  cat("[item_form] Building input list \n")
  cat("  - update =", update, "\n")

  # -- get parameters from data model
  colClasses <- dm_colClasses(data.model)
  skip <- data.model[data.model$skip, ]$name


  # -- helper function
  add_input <- function(x, colClasses, value){

    cat("  - Dealing with attribute :", names(colClasses), "/ type =", colClasses, "/ value =", value, "\n")

    # -- character
    if(colClasses == "character")
      input <- textInput(inputId = ns(names(colClasses)),
                         label = names(colClasses),
                         value = value,
                         width = NULL,
                         placeholder = NULL)

    # -- numeric, integer
    # removed double #218
    if(colClasses %in% c("numeric", "integer"))
      input <- numericInput(
        inputId = ns(names(colClasses)),
        label = names(colClasses),
        value = value,
        min = NA,
        max = NA,
        step = NA,
        width = NULL)

    # -- date, POSIXct
    if(colClasses %in% c("Date", "POSIXct"))
      input <- dateInput(
        inputId = ns(names(colClasses)),
        label = names(colClasses),
        value = value,
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

    # -- POSIXct (add time & timezone inputs)
    if(colClasses == "POSIXct"){

      # -- get timezone from value
      # Note: pick values matching with OlsonNames list
      # set default to Sys.timezone otherwise it will pick first choice
      tz_value <- attr(as.POSIXlt(value),"tzone")
      tz_value <- tz_value[tz_value %in% OlsonNames()]
      if(length(tz_value > 1))
        tz_value <- utils::head(tz_value, 1)
      if(length(tz_value == 0))
        tz_value <- Sys.timezone()

      # -- concatenate with date input
      input <- wellPanel(input,

                         # -- time (need to extract time from value)
                         timeInput(inputId = ns(paste0(names(colClasses), "_time")),
                                   label = paste(names(colClasses), "time"),
                                   value = strftime(value, format="%H:%M:%S")),

                         # -- timezone (need to extract tz from value)
                         selectizeInput(inputId = ns(paste0(names(colClasses), "_tz")),
                                        label = paste(names(colClasses), "timezone"),
                                        choices = OlsonNames(),
                                        selected = tz_value))}


    # -- logical
    if(colClasses == "logical"){

      # -- check value
      if(is.character(value))
        value <- as.logical(value)

      # -- check NA (in case no default has been set) #246
      if(is.na(value))
        value <- FALSE

      # -- input
      input <- checkboxInput(inputId = ns(names(colClasses)),
                             label = names(colClasses),
                             value = value,
                             width = NULL)
    }

    # -- return
    input

  }


  # -- Filter out attributes in skip param
  cat("  - Filter out attributes to skip:", skip, "\n")
  colClasses <- colClasses[!names(colClasses) %in% skip]

  # -- check
  # when id is the only attribute, colClasses will be empty #243
  if(length(colClasses) == 0)
    return("Warning: there is no attribute that requires an input value (all attributes are skipped!).")

  # -- Define default input values
  if(update){

    # -- Apply same filter on item to update
    values <- item[names(colClasses)]

  } else {

    cat("[item_form] get attributes defaults: \n")
    values <- lapply(names(colClasses), function(x) dm_default(data.model, x))
    names(values) <- names(colClasses)

  }

  # -- apply helper
  cat("[item_form] Loop on attributes: \n")
  feedback <- lapply(1:length(colClasses), function(x) add_input(x, colClasses[x], values[[x]]))

  # -- output
  tagList(feedback)

}
