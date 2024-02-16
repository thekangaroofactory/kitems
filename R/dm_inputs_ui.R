

#' Data model inputs UI
#'
#' @param update a logical to turn ui into update mode
#' @param attribute a dataframe of the attribute to be updated
#' @param names a character vector of choices for attribute name
#' @param types a character vector of choices for attribute type
#' @param ns the namespace function
#'
#' @return a form, as a result from renderUI function
#' @export
#'
#' @examples
#' # -- create mode
#' dm_inputs_ui()
#'
#' # -- update mode
#' \dontrun{
#' dm_inputs_ui(update = TRUE, attribute = dm[1, ])
#' }
#'


dm_inputs_ui <- function(update = FALSE, attribute = NULL,
                         names = NULL, types = NULL,
                         ns){

  # -- prepare values
  if(update){

    # -- check if selected attribute is id
    is_id <- if(attribute$name == "id")
      TRUE
    else
      FALSE

    # -- default val or fun
    default_choice <- if(is.na(attribute$default.fun)){
      if(is.na(attribute$default.val))
        "none"
      else
        "val"
    } else
      "fun"

    # -- default value
    default_detail <- if(is.na(attribute$default.fun))
      attribute$default.val
    else
      attribute$default.fun

    # -- skip
    skip <- attribute$skip

  } else {

    # -- show all at creation
    is_id <- FALSE

    # -- defaults for creation
    default_choice <- "none"
    default_detail <- NULL
    skip <- FALSE

  }


  # -- return
  renderUI({

    # -- build tag list
    tagList(

      # attribute name
      if(!update)
        selectizeInput(inputId = ns("dm_att_name"),
                       label = "Name",
                       choices = names,
                       selected = NULL,
                       options = list(create = TRUE,
                                      placeholder = 'Type or select an option below',
                                      onInitialize = I('function() { this.setValue(""); }'))),

      # attribute type
      if(!update)
        selectizeInput(inputId = ns("dm_att_type"),
                       label = "Type",
                       choices = types,
                       selected = NULL,
                       options = list(create = FALSE,
                                      placeholder = 'Type or select an option below',
                                      onInitialize = I('function() { this.setValue(""); }'))),


      # -- default val or fun (id should have default.fun only)
      if(!is_id)
        radioButtons(inputId = ns("dm_default_choice"),
                     label = "Choose default",
                     choices = c("no default" = "none", "value" = "val", "function" = "fun"),
                     selected = default_choice)
      else
        p("id can only receive a default function."),

      # -- default.val
      selectizeInput(inputId = ns("dm_att_default_detail"),
                     label = "Default detail",
                     choices = default_detail,
                     selected = default_detail,
                     options = list(create = TRUE)),

      # -- skip
      if(!is_id)
        checkboxInput(inputId = ns("dm_att_skip"),
                      label = "skip (input form)",
                      value = attribute$skip)
      else
        p("id must be skipped."),

      # -- action btn
      if(update)
        actionButton(ns("upd_att"), label = "Update attribute")
      else
        actionButton(ns("add_att"), label = "Add attribute"))

  })

}
