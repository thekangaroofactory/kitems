

#' Check items integrity
#'
#' @param items a data.frame of the items
#' @param data.model a data.frame of the data model
#'
#' @return a data.frame of the items, with corrected attribute types
#' @export
#'
#' @details
#' The function checks if the class of the attributes in items matches with
#' the one in the data model.
#' If not, it will coerce the values of the corresponding column to the data model class.
#'
#' @examples
#' \dontrun{
#' items <- item_integrity(items, data.model)
#' }


item_integrity <- function(items, data.model){

  # -- check args
  if(is.null(items) || is.null(data.model))
    return(items)

  # -- get dm colClasses
  colClasses <- dm_colClasses(data.model = data.model)

  # -- get items classes
  items_classes <- sapply(items, class)
  items_classes <- sapply(items_classes, "[[", 1)

  # -- columns to fix
  cols <- names(items_classes[items_classes != colClasses])

  # -- check: return input if nothing to do
  if(length(cols) == 0){
    cat("-- success, nothing to do \n")
    return(items)}

  # -- helper function
  helper <- function(att_name){

    item_class <- items_classes[att_name]
    dm_class <- colClasses[att_name]

    cat("[WARNING] Attribute", att_name, "class does not match with data model: \n")
    cat("-- items class =", item_class, "vs data.model type =", dm_class, "\n")

    # -- Wrapp attempt to coerce value
    new_values <- tryCatch(

      # -- expression
      expr =  {

        # -- coerce value
        output <- if(dm_class == "Date")
          as.Date(items[[att_name]])
        else
          eval(call(CLASS_FUNCTIONS[[dm_class]], items[[att_name]]))

        # -- return
        output

      },

      # -- catch error
      error = function(e){

        cat("[ERROR] Coerce", att_name, "to", dm_class, "did not work! \n")
        print(e)

        # -- setting output (see replace)
        output <- NULL},

      # -- catch warnings
      warning = function(w){

        print(w)
        output <- NULL

      })

    cat("   >> Check after conversion:", class(new_values), "\n")

    # -- return
    if(!is.null(new_values))
      new_values
    else
      items[[att_name]]

  }

  # -- apply helper (only on not matching columns)
  items[cols] <- lapply(cols, helper)

  # -- return
  items

}
