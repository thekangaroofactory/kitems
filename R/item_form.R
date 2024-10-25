

#' Build Item Form
#'
#' @param data.model the data.frame of the data model
#' @param items the data.frame of the items
#' @param update an optional logical (default = FALSE) to trigger update behavior
#' @param item an optional item (used to set default input values if update = TRUE)
#' @param shortcut a logical to indicate if shortcuts should be displayed
#' @param ns the namespace function, output of shiny::NS()
#'
#' @return a tagList() object containing the attribute inputs
#' @export
#'
#' @details
#' Data model skip feature will be used to return inputs only for the skip = FALSE attributes
#'
#' @examples
#' \dontrun{
#' item_form(data.model = mydata$data_model(), update = FALSE, item = NULL, ns)
#' item_form(data.model = mydata$data_model(), update = TRUE, item = myitem, ns)
#' }

item_form <- function(data.model, items, update = FALSE, item = NULL, shortcut = FALSE, ns){

  cat("[item_form] Building input list \n")
  cat("  - update =", update, "\n")

  # -- get parameters from data model
  colClasses <- dm_colClasses(data.model)
  skip <- data.model[data.model$skip, ]$name

  # -- Filter out attributes in skip param
  cat("  - Filter out attributes to skip:", skip, "\n")
  colClasses <- colClasses[!names(colClasses) %in% skip]

  # -- check
  # when id is the only attribute, colClasses will be empty #243
  if(length(colClasses) == 0)
    return("There is no attribute that requires an input value (all attributes are skipped!).")

  # -- Define default input values
  if(update){

    # -- Apply skip on item to update
    values <- item[names(colClasses)]

  } else {

    cat("[item_form] get attributes defaults: \n")
    values <- lapply(names(colClasses), function(x) dm_default(data.model, x))
    names(values) <- names(colClasses)

  }

  # -- apply attribute_input
  cat("[item_form] Build attribute input: \n")
  feedback <- lapply(1:length(colClasses), function(x) attribute_input(colClasses[x], values[[x]], ns))

  # -- apply attribute_shortcut
  if(shortcut){
    cat("[item_form] Build attribute shortcuts: \n")
    shortcuts <- lapply(1:length(colClasses), function(x)
      attribute_shortcut(colClass = colClasses[x],
                         suggestions = attribute_suggestion(values = items[, names(colClasses[x])]),
                         ns))}

  # -- output
  if(shortcut)
    tagList(lapply(1:length(colClasses), function(x)
      div(feedback[x], shortcuts[x], style = 'margin-bottom: 10px;')))
  else
    feedback

}
