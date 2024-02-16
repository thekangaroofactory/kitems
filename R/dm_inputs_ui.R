

#' Data model inputs UI
#'
#' @param update a logical to turn ui into update mode
#' @param attribute a dataframe of the attribute to be updated
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


dm_inputs_ui <- function(update = FALSE, attribute = NULL, ns){

  # -- prepare values
  if(update){

    # -- defalt val or fun
    default_choice <- if(is.na(attribute$default.fun))
      "val"
    else
      "fun"

    # -- default value
    default_detail <- if(is.na(attribute$default.fun))
      attribute$default.val
    else
      attribute$default.fun

    # -- skip
    skip <- attribute$skip

  } else {

    # -- defaults for creation
    default_choice <- "val"
    default_detail <- NULL
    skip <- FALSE

  }


  # -- return
  renderUI({

    # -- build tag list
    tagList(

      # -- default val or fun (id should have default.fun only)
      if(attribute$name != "id")
        radioButtons(inputId = ns("dm_default_choice"),
                     label = "Choose default",
                     choices = c("value" = "val", "function" = "fun"),
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
      if(attribute$name != "id")
        checkboxInput(inputId = ns("upd_att_skip"),
                      label = "skip",
                      value = attribute$skip)
      else
        p("id must be skipped."),

      # -- action btn
      if(update)
        actionButton(ns("upd_att"), label = "Update attribute"))

  })

}
