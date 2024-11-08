

#' Build Attribute Shortcuts
#'
#' @param colClass a length-one named vector. \code{names(colClass)} is the name of the attribute,
#' and \code{colClass} is the type (class) of the attribute.
#' @param suggestions a list of suggestions, output of \link[kitems]{attribute_suggestion}
#' @param ns the module namespace function reference
#'
#' @seealso [attribute_suggestion()] [item_form()]
#'
#' @return a list of actionLink objects
#'
#' The return value is the output of \link[base]{lapply} applying \link[shiny]{actionLink} over \code{suggestions}
#'
#' The actionLink has an \code{onclick} property that will trigger \code{input$shortcut_trigger} (\code{ns(shortcut_trigger)})
#' Its value is of the form \code{[ns]-[attribute]_[value]}
#' Basically, applying \code{tail(unlist(strsplit(input$shortcut_trigger, split = "-")), 1)} will access attribute_value
#'
#' Note that for POSIXct attribute, the shortcut_trigger input will not carry the timezone information.
#' Clicking on the corresponding actionLink will only trigger date & time inputs update.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' attribute_shortcut(colClass = c(name = "character"),
#' suggestions = list(mango = 25, banana = 12, lemon = 10),
#' ns = session$ns)
#' }


attribute_shortcut <- function(colClass, suggestions, ns){

  # -- check colClass
  if(is.null(names(colClass)) | !colClass %in% OBJECT_CLASS)
    stop("colClass has either no name or value does not fit with supported class (see OBJECT_CLASS)")

  catl("[attribute_shortcut] attribute :", names(colClass), "/ type =", colClass, "/ suggestions =", length(suggestions))

  # -- init
  shortcuts <- NULL

  # -- character
  # list(value1 = frequency, value_2, = frequency, ...)
  if(colClass %in% c("character", "factor", "logical"))

    # -- apply over suggestions
    shortcuts <- lapply(1:length(suggestions), function(x)
      actionLink(inputId = paste(ns(names(colClass)), names(suggestions[x]), sep = "_"),
                 label = paste(names(suggestions[x]), paste0("(", suggestions[x], "%)")),
                 icon = icon("bolt"),
                 onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                   ns("shortcut_trigger"))))


  # -- numeric, integer
  # list may have two different structure
  if(colClass %in% c("numeric", "integer")){

    # -- check suggestions
    isStats <- all(c('min', 'max', 'mean', 'median') %in% names(suggestions))

    # -- apply over suggestions
    shortcuts <- lapply(1:length(suggestions), function(x)
      actionLink(inputId = paste(ns(names(colClass)), ifelse(isStats, suggestions[x], names(suggestions[x])), sep = "_"),
                 label = paste(names(suggestions[x]), paste0("(", suggestions[x], ifelse(isStats, ")", "%)"))),
                 icon = icon("bolt"),
                 onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                   ns("shortcut_trigger"))))}


  # -- Date, POSIXct
  # suggestion values need to be coerced to target type (otherwise numeric)
  if(colClass %in% c("Date", "POSIXct"))

    # -- apply over suggestions
    shortcuts <- lapply(1:length(suggestions), function(x)
      actionLink(inputId = paste(ns(names(colClass)), suggestions[x], sep = "_"),
                 label = paste(names(suggestions[x]), paste0("(", eval(call(CLASS_FUNCTIONS[[colClass]], suggestions[[x]])), ")")),
                 icon = icon("bolt"),
                 onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                   ns("shortcut_trigger"))))


  # -- return
  shortcuts

}
