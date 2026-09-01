

#' Attribute Card
#'
#' @description
#' This is a UI layout function to display attributes.
#'
#' @param attribute the yaml of the attribute
#' @param item the name (id) of the item group
#' @param hide the list of attributes to hide
#' @param skip the list of attributes to skip
#' @param refresh the list of attributes to refresh
#'
#' @returns A htmltools::div() tag.
#'
#' @examples
#' \dontrun{
#' admin_attribute_card(attribute, item)
#' }

admin_attribute_card <- function(attribute, item, hide = NULL, skip = NULL, refresh = NULL){

  # -- wrapper
  # the wrapper is needed to locate the 'div:last' inside the layout_column_wrap
  div(class="bslib-grid-item bslib-gap-spacing html-fill-container",
      id = paste(item, attribute$name, "attribute-card-container", sep = "-"),

      bslib::card(
        id = paste(item, attribute$name, "attribute-card", sep = "-"),

        # -- attribute name
        bslib::card_header(class = "d-flex justify-content-between",
                           attribute$name,
                           div(
                             if(attribute$name %in% hide)
                               bslib::tooltip(icon("eye-slash"), "The attribute is not displayed"),
                             if(attribute$name %in% skip)
                               bslib::tooltip(icon("bolt-lightning"), "The attribute is skipped"),
                             if(attribute$name %in% refresh)
                               bslib::tooltip(icon("rotate"), "The attribute will be refreshed upon update"))),

        # -- content
        bslib::card_body(

          # -- mandatory
          p("type:", attribute$type),
          if("class.arg" %in% names(attribute))
            p("Class argument(s):", attribute$class.arg),

          # -- values
          if("values" %in% names(attribute))
            p("Values:", attribute$values),

          # -- optional
          if("default" %in% names(attribute))
            p("default:", attribute$default)

        ),

        bslib::card_footer(class = "d-flex justify-content-end",

                           # -- id attribute is frozen
                           if(attribute$name == "id")
                             span(class = "text-primary", "id is frozen.")

                           else
                             tagList(
                               ktools::action_link(id = attribute$name,
                                                   label = "",
                                                   icon = icon("gear"),
                                                   target = "attribute_action",
                                                   pattern = paste0(item, "-attribute_update")),
                               ktools::action_link(id = attribute$name,
                                                   label = "",
                                                   icon = icon("arrows-left-right"),
                                                   target = "attribute_action",
                                                   pattern = paste0(item, "-attribute_move")),
                               ktools::action_link(id = attribute$name,
                                                   label = "",
                                                   icon = icon("trash"),
                                                   target = "attribute_action",
                                                   pattern = paste0(item, "-attribute_delete"))))))

}


#' Attribute Modal Window
#'
#' @description
#' This is the UI layout function for the attribute wizard.
#'
#' @param update whether it is an update or not
#'
#' @details
#' Mostly composed of container div elements that will be filled / updated
#' dynamically.
#'
#' @returns a modal dialog
#'
#' @examples
#' \dontrun{
#' admin_attribute_modal()
#' }

admin_attribute_modal <- function(update = FALSE){

  # -- return
  modalDialog(
    title = paste(ifelse(update, "Update", "Create"), "Attribute"),
    size = "l",

    # -- input container
    div(id = "input-container"),

    # -- validation container
    uiOutput("w_validation"),

    # -- footer
    footer = tagList(
      actionButton(inputId = "w_cancel", label = "Cancel"),
      uiOutput("w_actions"),
      div(id = "action-container")))

}
