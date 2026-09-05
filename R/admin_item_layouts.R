

#' Item Layout
#'
#' @description
#' This is a UI / Layout function for the Admin Console
#'
#' @param x the item config
#'
#' @returns a bslib::nav_panel() object
#'
#' @examples
#' \dontrun{
#' admin_item_layout(item_config)
#' }

admin_item_layout <- function(x){

  # -- return
  bslib::nav_panel(title = x$id,
                   icon = icon(name = "box"),

                   # -- sidebar
                   bslib::layout_sidebar(
                     border = FALSE,

                     sidebar = bslib::sidebar(
                       position = "right",
                       width = 300,
                       open = TRUE,

                       h3("Source"),
                       p("Type:", x$source$type, br(),
                         if(x$source$type == "file")
                           paste("path:", x$source$path)),

                       h3("Skipped"),
                       p("No input will be generated for those attributes when creating / updating items."),
                       span(id = paste0(x$id, "-skipped-attributes"), class = "text-warning", paste(x$data.model$skip, collapse = "|")),

                       h3("Refreshed"),
                       p("Skipped attributes that will be refreshed when updating items."),
                       span(id = paste0(x$id, "-refreshed-attributes"), class = "text-warning", paste(x$data.model$refresh, collapse = "|")),

                       h3("Hidden"),
                       p("Attributes that won't be displayed in the item table."),
                       span(id = paste0(x$id, "-hidden-attributes"), class = "text-warning", paste(x$data.model$hide, collapse = "|")),

                       h3("Danger zone"),
                       div(id = paste0(x$id, "_dz_container"),
                           bslib::input_switch(id = paste0(x$id, "_dz"), label = "Allow"))),

                     # -- main content
                     h1(id = paste0(x$id, "-attribute-nb"),
                        class = "mb-3",
                        admin_attribute_nb(x)),

                     # -- call the attribute card function with extra arguments (hide, skip..)
                     bslib::layout_column_wrap(
                       id = paste0(x$id, "-attributes"),
                       fill = FALSE,
                       !!!lapply(x$data.model$attributes,
                                 admin_attribute_card,
                                 x$id,
                                 hide = x$data.model$hide,
                                 skip = x$data.model$skip,
                                 refresh = x$data.model$refresh),

                       # -- add attribute
                       p(ktools::action_link(id = "x",
                                             label = "Add",
                                             target = "attribute_action",
                                             pattern = paste0(x$id, "-attribute_create")),
                         "an attribute to the item group.")),

                     h2("Sorting"),
                     p(ktools::action_link(id = "x",
                                           label = "",
                                           icon = icon("gear"),
                                           target = "sorting_action",
                                           pattern = paste0(x$id, "-sorting_action")),
                       span(id = paste0(x$id, "-sorting"), class = "text-warning",
                            if(is.null(x$data.model$sort)) "No sorting is defined." else paste(x$data.model$sort, collapse = "|")))))

}


#' Item Card
#'
#' @description
#' This is a UI / Layout function for the Admin Console
#'
#' @param name the name of the item
#' @param description an optional description
#'
#' @returns a div() HTML object
#'
#' @examples
#' \dontrun{
#' admin_item_card("date")
#' }

admin_item_card <- function(name, description = NULL){

  # -- return
  div(class="bslib-grid-item bslib-gap-spacing html-fill-container",
      id = paste0(name, "-item-card"),
      bslib::card(
        bslib::card_header(name),
        p(id = paste0(name, "-description"), "Description:", description),

        # -- update description
        ktools::action_link(id = "x",
                            label = "Update description",
                            icon = icon("gear"),
                            target = "item_update_description",
                            pattern = paste0(name, "-update_description")),

        # -- switch to item tab
        ktools::action_link(id = "x",
                            label = "Switch to item tab",
                            icon = icon("circle-arrow-right"),
                            target = "select_tab",
                            pattern = paste0(name, "-select_tab"))))

}


#' Item Danger Zone
#'
#' @description
#' This is a UI / Layout function for the Admin Console
#'
#' @param name the name of the item
#'
#' @returns an HTML tag
#'
#' @examples
#' \dontrun{
#' admin_item_dz("date")
#' }

admin_item_dz <- function(name){

  ktools::action_link(id = "x",
                      label = "Delete item group",
                      icon = icon("circle-arrow-right"),
                      target = "item_delete",
                      pattern = paste0(name, "-delete"))

}
