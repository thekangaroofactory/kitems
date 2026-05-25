

#' Items Integrity
#'
#' @description
#' Check items integrity vs the data model.
#'
#'
#' @param items a data.frame of the items.
#' @param data.model a data.frame of the data model.
#' @param fix a logical (default = `FALSE`) if the items should be fixed.
#'
#' @return A data.frame of the items, with corrected attribute types.
#' @export
#'
#' @details
#' The function checks if the class of the attributes in items matches with
#' the one in the data model.
#'
#' If not, and if `fix` is TRUE, it will coerce the values of the corresponding
#' column to the data model class.
#' If `fix` is FALSE, it will raise an error.
#'
#' @examples
#' \dontrun{
#' items <- item_integrity(items, data.model, fix = TRUE)
#' }

item_integrity <- function(items, data.model, fix = FALSE){

  # -- check args
  if(is.null(items) || is.null(data.model))
    return(NULL)

  # ////////////////////////////////////////////////////////////////////////////
  # Check

  # -- get dm colClasses
  colClasses <- dm_colClasses(data.model = data.model)

  # -- get items classes
  # when POSIXct, two classes will be found
  items_classes <- sapply(items, class)
  if(is.list(items_classes))
    items_classes <- sapply(items_classes, "[[", 1)

  # -- columns to fix
  # make sure attributes comes with same order #597
  cols <- names(items_classes[items_classes != colClasses[names(items_classes)]])

  # -- check: return if nothing to do or fix not required
  if(length(cols) == 0)
    return(NULL)
  else if(!fix) stop(cols, " do(es) not match with data model type(s).")


  # ////////////////////////////////////////////////////////////////////////////
  # Fix

  # -- helper function
  helper <- function(att_name){

    item_class <- items_classes[att_name]
    dm_class <- colClasses[att_name]

    warning("Attribute ", att_name, " class does not match with data model: \n",
            "-- items class = ", item_class, " vs data.model type = ", dm_class)

    # -- Wrap attempt to coerce value
    new_values <- tryCatch(

      # -- expression
      expr =  {

        # -- coerce value
        output <- if(dm_class == "Date")
          as.Date(items[[att_name]])
        else
          convert(x = items[[att_name]],
                  class = dm_class,
                  class.arg = data.model[data.model$name == att_name, ]$class.arg)

        # -- return
        output

      },

      # -- catch error
      error = function(e){

        warning("Coerce ", att_name, " to ", dm_class, " did not work!")
        message(e$message)

        # -- setting output (see replace)
        output <- NULL},

      # -- catch warnings
      warning = function(w){

        warning(w$message)
        output <- NULL

      })

    message(">> Check after conversion:", class(new_values))

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
