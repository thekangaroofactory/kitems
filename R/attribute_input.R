

#' Attribute Input
#'
#' @description
#' Build input for an attribute
#'
#' @param colClass a length-one named vector. \code{names(colClass)} is the name of the attribute,
#' and \code{colClass} is the type (class) of the attribute.
#' @param value the value used to initialize the input
#' @param ns the namespace function reference
#'
#' @return An input that can be added to the UI definition.
#' @export
#'
#' @examples
#' \dontrun{
#' # -- namespace
#' ns <- shiny::NS("my_data")
#'
#' # -- create inputs
#' attribute_input(colClass = c(name = "character"), ns)
#' attribute_input(colClass = c(total = "numeric"), value = 10, ns)
#' }

attribute_input <- function(colClass, value = NULL, ns){

  # -- check colClass
  if(is.null(names(colClass)) | !colClass %in% OBJECT_CLASS)
    stop("colClass has either no name or value does not fit with supported class (see OBJECT_CLASS)")

  catl("- [attribute_input] name =", names(colClass), "/ type =", colClass, "/ value =", value)

  # -- compute inputId & label
  name <- names(colClass)
  input_id <- ns(name)
  label <- stringr::str_to_title(name)

  # -- character
  if(colClass == "character")
    input <- textInput(inputId = input_id,
                       label = label,
                       value = value,
                       width = NULL,
                       placeholder = NULL)

  # -- numeric, integer
  # removed double #218
  if(colClass %in% c("numeric", "integer"))
    input <- numericInput(
      inputId = input_id,
      label = label,
      value = value,
      min = NA,
      max = NA,
      step = NA,
      width = NULL)

  # -- date, POSIXct
  if(colClass %in% c("Date", "POSIXct"))
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
  if(colClass == "POSIXct"){

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
                       timeInput(inputId = ns(paste0(name, "_time")),
                                 label = paste(label, "time"),
                                 value = strftime(value, format="%H:%M:%S")),

                       # -- timezone (need to extract tz from value)
                       selectizeInput(inputId = ns(paste0(name, "_tz")),
                                      label = paste(label, "timezone"),
                                      choices = OlsonNames(),
                                      selected = tz_value))}


  # -- logical
  if(colClass == "logical"){

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
