


attribute_shortcut <- function(colClass, suggestions, ns){

  # -- check colClass
  if(is.null(names(colClass)) | !colClass %in% OBJECT_CLASS)
    stop("colClass has either no name or value does not fit with supported class (see OBJECT_CLASS)")

  cat("[attribute_shortcut] attribute :", names(colClass), "/ type =", colClass, "/ suggestions =", length(suggestions), "\n")

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
                                   ns("xxxx_trigger"))))


  # -- numeric, integer
  # list may have two different structure
  if(colClass %in% c("numeric", "integer")){

    # -- check suggestions
    pct <- ifelse(all(c('min', 'max', 'mean', 'median') %in% names(suggestions)), "", "%")

    # -- apply over suggestions
    shortcuts <- lapply(1:length(suggestions), function(x)
      actionLink(inputId = paste(ns(names(colClass)), names(suggestions[x]), sep = "_"),
                 label = paste(names(suggestions[x]), paste0("(", suggestions[x], pct, ")")),
                 icon = icon("bolt"),
                 onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                   ns("xxxx_trigger"))))}


  # -- logical
  # if(colClass == "logical")
  #
  #   # -- apply over suggestions
  #   shortcuts <- lapply(1:length(suggestions), function(x)
  #     actionLink(inputId = paste(ns(names(colClass)), names(suggestions[x]), sep = "_"),
  #                label = paste(names(suggestions[x]), paste0("(", suggestions[x], "%)")),
  #                icon = icon("bolt"),
  #                onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
  #                                  ns("xxxx_trigger"))))


  # -- Date, POSIXct
  # suggestion values need to be coerced to target type (otherwise numeric)
  if(colClass %in% c("Date", "POSIXct"))

    # -- apply over suggestions
    shortcuts <- lapply(1:length(suggestions), function(x)
      actionLink(inputId = paste(ns(names(colClass)), names(suggestions[x]), sep = "_"),
                 label = paste(names(suggestions[x]), paste0("(", eval(call(CLASS_FUNCTIONS[[colClass]], suggestions[[x]])), ")")),
                 icon = icon("bolt"),
                 onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                   ns("xxxx_trigger"))))

  # -- return
  shortcuts

}
