

#' Item Form
#'
#' @description
#' Builds the create or update item form.
#'
#' @param data.model the data.frame of the data model.
#' @param ns the namespace function, output of `shiny::NS()`.
#'
#' @return A list of HTML input objects.
#' @export
#'
#' @details
#' Possible values for workflow are "create" (the default) or "update".
#'
#' @examples
#' \dontrun{
#' item_form(data.model = mydata$data_model(), ns)
#' item_form(data.model = mydata$data_model(), ns)
#' }

item_form <- function(data.model, ns){

  # -- check argument
  if(nrow(data.model) == 0)
    return(NULL)

  # -- apply attribute_input over the input
  # note: faster than apply over data.frame + as.list the output
  lapply(1:nrow(data.model), function(x) attribute_input(name = data.model[x, 'name'], type = data.model[x, 'type'], value = data.model[x, 'default'], ns))

}
