

#' Attribute Card
#'
#' @description
#' This is a UI layout function to display attributes.
#'
#' @param attribute the yaml of the attribute
#' @param item the name of the item
#' @param hide the list of attributes to hide
#' @param skip the list of attributes to skip
#' @param update the listf of attributes to update
#'
#' @returns A htmltools::div() tag.
#'
#' @examples
#' \dontrun{
#' admin_attribute_card(attribute, item)
#' }

admin_attribute_card <- function(attribute, item, hide = NULL, skip = NULL, update = NULL){

  # -- wrapper
  # the container is needed to locate the 'div:last' inside the layout_column_wrap
  div(class="bslib-grid-item bslib-gap-spacing html-fill-container",
      id = paste(item, attribute$name, "attribute-card", sep = "-"),

      bslib::card(

        # -- attribute name
        bslib::card_header(class = "d-flex justify-content-between",
                           attribute$name,
                           div(
                             if(attribute$name %in% hide)
                               bslib::tooltip(icon("eye-slash"), "The attribute is not displayed"),
                             if(attribute$name %in% skip)
                               bslib::tooltip(icon("bolt-lightning"), "The attribute is skipped"),
                             if(attribute$name %in% update)
                               icon("rotate"))),

        # -- content
        bslib::card_body(

          # -- mandatory
          p("type:", attribute$type),

          # -- optional
          if("default" %in% names(attribute))
            p("default value:", attribute$default)

        ),

        bslib::card_footer(class = "d-flex justify-content-end",

                           actionLink(inputId = paste0(item, "-attribute_update_", attribute$name),
                                      label = "",
                                      icon = icon("gear"),
                                      onclick = ktools::onclick_event(target = "attribute_action")),

                           actionLink(inputId = paste0(item, "-attribute_move_", attribute$name),
                                      label = "",
                                      icon = icon("arrows-left-right"),
                                      onclick = ktools::onclick_event(target = "attribute_action")),

                           actionLink(inputId = paste0(item, "-attribute_delete_", attribute$name),
                                      label = "",
                                      icon = icon("trash"),
                                      onclick = ktools::onclick_event(target = "attribute_action")))))

}


#' Attribute Modal Window
#'
#' @description
#' This is the UI layout function for the attribute wizard.
#'
#' @details
#' Mostly composed of container div elements that will be filled / updated
#' dynamically.
#'
#' @returns a modal dialog
#'
#' @examples
#' admin_attribute_modal()

admin_attribute_modal <- function(){

  # -- return
  modalDialog(
    title = "Create Attribute",
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
