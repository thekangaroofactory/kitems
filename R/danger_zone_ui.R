

#' Danger zone UI
#'
#' @param k_data_model the reference of the data model reactive value
#' @param ns the namespace function
#'
#' @return a tagList object
#'
#' @examples
#' \dontrun{
#' danger_zone_ui(k_data_model, ns)
#' }

danger_zone_ui <- function(k_data_model, ns) {

  # -- return
  tagList(

    # -- delete attribute
    shinydashboard::box(title = "Delete attribute", status = "danger", width = 4,

                        tagList(

                          # -- select attribute name
                          selectizeInput(inputId = ns("dz_delete_att_name"),
                                         label = "Name",
                                         choices = k_data_model()$name,
                                         selected = NULL,
                                         options = list(create = FALSE,
                                                        placeholder = 'Type or select an option below',
                                                        onInitialize = I('function() { this.setValue(""); }'))),

                          # -- delete att
                          actionButton(ns("dz_delete_att"), label = "Delete"))),

    # -- delete data model
    shinydashboard::box(title = "Delete data model", status = "danger", width = 4,
                        p("Click here to delete the data model and ALL corresponding items."),
                        actionButton(ns("dz_delete_dm"), label = "Delete all!")))

}
