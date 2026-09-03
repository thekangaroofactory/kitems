

#' Attribute Input
#'
#' @description
#' Build input for an attribute
#'
#' @param name the name of the attribute.
#' @param type the type of the attribute.
#' @param value the value to be used to initialize the input.
#' @param choices a list of values to select from (see details).
#' @param create a logical (default = FALSE) if user is allowed to create values (see details)
#' @param ns the namespace function reference.
#'
#' @details
#' By default (`choices = NULL`), the function will return an input driven by the
#' type of the attribute.
#' When `choices` are provided, it will be replaced by a selectizeInput. User
#' will be allowed to create additional values depending on `create` (otherwise ignored).
#'
#' @return An input that can be added to the UI definition.
#' @export
#' @importFrom shinyWidgets timeInput
#'
#' @examples
#' \dontrun{
#' # -- namespace
#' ns <- shiny::NS("my_data")
#'
#' # -- create inputs
#' attribute_input(name = "total", type = "numeric", value = 10, ns)
#' }

attribute_input <- function(name, type, value = NULL, choices = NULL, create = FALSE, ns){

  # -- check arguments
  if(is.null(name))
    stop("name is required")

  if(!type %in% OBJECT_CLASS)
    stop("type does not fit with supported class (see OBJECT_CLASS)")

  catl("- [attribute_input] name =", name, "/ type =", type, "/ value =", value)

  # -- compute inputId & label
  input_id <- ns(name)
  label <- stringr::str_to_title(name)


  # -- attribute values
  # when choices are provided, type driven input it replaced by a selectInput
  if(!is.null(choices))
    input <- selectizeInput(inputId = input_id,
                            label = label,
                            choices = choices,
                            selected = value,
                            options = list(create = create))

  # -- character
  if(type == "character")
    input <- textInput(inputId = input_id,
                       label = label,
                       value = value,
                       width = NULL,
                       placeholder = NULL)

  # -- numeric, integer
  # removed double #218
  if(type %in% c("numeric", "integer"))
    input <- numericInput(
      inputId = input_id,
      label = label,
      value = value,
      min = NA,
      max = NA,
      step = NA,
      width = NULL)

  # -- date, POSIXct
  if(type %in% c("Date", "POSIXct"))
    input <- dateInput(
      inputId = input_id,
      label = label,
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
  if(type == "POSIXct"){

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
                       shinyWidgets::timeInput(inputId = ns(paste0(name, "_time")),
                                 label = paste(label, "time"),
                                 value = strftime(value, format="%H:%M:%S")),

                       # -- timezone (need to extract tz from value)
                       selectizeInput(inputId = ns(paste0(name, "_tz")),
                                      label = paste(label, "timezone"),
                                      choices = OlsonNames(),
                                      selected = tz_value))}


  # -- logical
  if(type == "logical"){

    # -- check value
    if(is.character(value))
      value <- as.logical(value)

    # -- check NA (in case no default has been set) #246
    if(is.na(value))
      value <- FALSE

    # -- input
    input <- checkboxInput(inputId = input_id,
                           label = label,
                           value = value,
                           width = NULL)
  }

  # -- return
  input

}
