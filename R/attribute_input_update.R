

#' Update Attribute Input
#'
#' @param data.model the reference of the data model reactiveVal
#' @param shortcut_trigger basically the value of input$shortcut_trigger
#' @param MODULE an optional character string for the trace
#'
#' @importFrom utils tail
#'
#' @examples
#' \dontrun{
#' attribute_input_update(
#' data.model = mydata$data_model,
#' shortcut_trigger = "name_banana",
#' MODULE = "(mydata)")
#' }

attribute_input_update <- function(data.model, shortcut_trigger, MODULE = NULL){

  # -- get attribute & value
  key_value <- tail(unlist(strsplit(shortcut_trigger, split = "-")), 1)
  key_value <- unlist(strsplit(key_value, split = "_"))
  name <- key_value[1]
  input_id <- name
  value <- key_value[2]
  type <- data.model()[data.model()$name == name, ]$type
  cat(MODULE, "Shortcut onclick, attribute =", name, "/ type =", type, "/ value =", value, "\n")

  # -- character
  if(type == "character")
    updateTextInput(inputId = input_id, value = value)

  # -- numeric, integer
  if(type %in% c("numeric", "integer"))
    updateNumericInput(inputId = input_id, value = value)

  # -- date
  if(type == "Date")
    updateDateInput(inputId = input_id, value = as.Date(as.numeric(value), origin = "1970-01-01"))

  # -- POSIXct
  # timezone is not updated since the value received from in the input has no tz info
  if(type == "POSIXct"){

    # -- prepare value
    value <- as.POSIXct(as.numeric(value), origin = "1970-01-01")

    # -- date
    updateDateInput(inputId = input_id, value = as.Date(value))

    # -- time (need to extract time from value)
    updateTimeInput(inputId = paste0(name, "_time"), value = strftime(value, format="%H:%M:%S"))}


  # -- logical
  if(type == "logical")
    updateCheckboxInput(inputId = input_id, value = as.logical(value))

}
