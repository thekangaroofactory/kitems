

#' Missing Config Layout
#'
#' @description
#' This is a UI / Layout function for the Admin Console
#'
#' @returns an HTML tag (div)
#'
#' @examples
#' \dontrun{
#' admin_no_yaml_layout()
#' }

admin_no_yaml_layout <- function(){

  div(id = "home-no-yaml",
      h1("Welcome"),
      h2("There is no YAML configuration available for this project."),
      p("Click", actionLink(inputId = "yaml_create", label = "here"), "to create one."))

}


# ------------------------------------------------------------------------------
# Helper functions to compute messages
# ------------------------------------------------------------------------------


#' YAML Messages
#'
#' @description
#' This is a helper function to return messages about the YAML config.
#'
#' @param config a YAML config
#'
#' @returns an HTML tag
#'
#' @examples
#' \dontrun{
#' admin_yaml_message(config)
#' }

admin_yaml_message <- function(config){

  if(is.null(config))
    return(p(class = "text-warning", icon("circle-chevron-right"), "The project has no config file!"))

  if(is.null(config$items))
    return(p(class = "text-warning", icon("circle-chevron-right"), "The project has no item yet."))

  if(!is.null(config$version))
    return(p(class = "text-success-emphasis", icon("circle-chevron-right"), "Version:", config$version))

}


#' Attribute Number
#'
#' @param config an item config
#'
#' @returns a character string
#'
#' @examples
#' \dontrun{
#' admin_attribute_nb(config)
#' }

admin_attribute_nb <- function(config){

  nb <- length(config$data.model$attributes)
  paste0(nb, " attribute", if(nb > 1) "s")

}
