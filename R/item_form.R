

#' Item Form
#'
#' @description
#' Builds the create or update item form.
#'
#' @param attributes a data.frame of the attributes (see details).
#' @param items a data.frame of the items (see details).
#' @param ns the namespace function, output of `shiny::NS()`.
#'
#' @details
#' `attributes` is expected to be the output of the `dm_default()` function.
#' The data.frame should have the following columns:
#' "name", "type", "default", "values".
#'
#' `items` are required only when the attribute values defined in the data.model
#' should be evaluated with data masking support.
#'
#' @return A list of HTML tags.
#' @export
#'
#' @examples
#' \dontrun{
#' item_form(attributes = dm_default(data_model()), ns) << check this!
#' }

item_form <- function(attributes, items = NULL, ns){

  # -- check argument
  if(nrow(attributes) == 0)
    return(NULL)

  # -- apply attribute_input over the input
  # note: faster than apply over data.frame + as.list the output
  lapply(1:nrow(attributes), function(x) {

    attribute_input(name = attributes[x, 'name'],
                    type = attributes[x, 'type'],
                    value = attributes[x, 'default'],
                    choices = if(is_truthy(attributes[[x, 'values']])) dm_values(attributes[[x, 'values']], data = items) else NULL,
                    create = rlang::is_call(rlang::parse_expr(attributes[[x, 'values']]), name = "suggest"),
                    ns)

    })

}
