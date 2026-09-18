

#' Admin Console Layout
#'
#' @description
#' This is a UI / Layout function for the Admin Console.
#'
#' @details
#' The main layout will be used to dynamically insert / remove content
#' from the server side.
#'
#' @returns an HTML tag.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' admin_layout()
#' }

admin_layout <- function(){

  bslib::page_navbar(title = "Admin Console",
                     window_title = "Kitems Admin Console",
                     id = "nav",
                     fillable = FALSE,

                     # -- allow shinyjs
                     header = shinyjs::useShinyjs(),

                     # -- home tab (persistent)
                     bslib::nav_panel(title = "Home",
                                      value = "home",
                                      icon = icon(name = "home"),

                                      # -- layout
                                      bslib::layout_sidebar(
                                        border = FALSE,

                                        # -- sidebar
                                        sidebar = bslib::sidebar(
                                          id = "home-sidebar",
                                          position = "right",
                                          width = 300,
                                          open = FALSE,

                                          # -- yaml
                                          h3("YAML", icon("gears")),
                                          textOutput("yaml_file"),
                                          uiOutput("yaml_message")),

                                        # -- main
                                        # container where to insert elements
                                        h1(class = "mb-3", textOutput("project_name")),

                                        # -- wrapper
                                        div(id = "home-project-items-section",
                                            bslib::layout_column_wrap(
                                              id = "home-project-items",
                                              bslib::card(id = "home-items-create",
                                                          p(actionLink(inputId = "item_create", label = "Add"), "an item group to the project.")))))),

                     # -- space
                     # To ensure dark mode switch is on right
                     bslib::nav_spacer(),

                     # -- link to package documentation
                     bslib::nav_item(
                       a(href="https://thekangaroofactory.github.io/kitems/", "kitems", target = "_blank")),

                     # -- dark mode switch
                     bslib::nav_item(
                       bslib::input_dark_mode(id = "dark", mode = NULL)),

                     footer = paste0("kitems v", as.character(utils::packageVersion("kitems"))))

}


#' Missing Config Layout
#'
#' @description
#' This is a UI / Layout function for the Admin Console
#'
#' @returns an HTML tag (div)
#' @keywords internal
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
#' @keywords internal
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
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' admin_attribute_nb(config)
#' }

admin_attribute_nb <- function(config){

  nb <- length(config$data.model$attributes)
  paste0(nb, " attribute", if(nb > 1) "s")

}
