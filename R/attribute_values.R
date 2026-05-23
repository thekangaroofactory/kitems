

#' Validate Value(s)
#'
#' @description
#' Validate the input values and turn them into item(s)
#'
#' @param values a list of input values.
#' @param data.model the data.frame of the data model.
#' @param update whether the id attribute should be checked or not (default FALSE).
#'
#' @returns A data.frame of item(s) checked against the data model.
#' @export
#'
#' @examples
#' \dontrun{
#' attribute_values(values, data.model)}

attribute_values <- function(values, data.model, update = FALSE){

  # the input for this function will be the named values instead of key/value
  # - extract from the input
  # - prepared from the trigger (squared)
  # >> done

  # ////////////////////////////////////////////////////////////////////////////
  # -- helper function
  # dealing with a single attribute

  helper <- function(key, value, att_dm){

    # -- input summary (debug)
    catl("Process attribute: key =", key)
    catl("- input value =", as.character(value), level = 2)

    # //////////////////////////////////////////////////////////////////////////
    # -- Validate or replace value(s)

    # -- depends on single / multiple values
    if(length(value) <= 1){

      if(!is_truthy(value)){
        catl("> invalid input / set default", level = 2)
        value <- dm_default(att_dm)$default}

    } else {

      # -- get valid values
      is_valid <- sapply(value, is_truthy)

      # -- replace invalid ones by default
      if(any(!is_valid)){
        catl("> invalid input(s) / set default where needed", level = 2)
        value[!is_valid] <- replicate(dm_default(att_dm)$default, n = length(value[!is_valid]))}

    }

    # //////////////////////////////////////////////////////////////////////////
    # -- check vs target class
    # value might have several classes (case POSIX*)

    # -- input summary (debug)
    catl("- target class =", att_dm$type, level = 2)

    if(!att_dm$type %in% class(value)){
      catl("> Class:", class(value), "does not fit with:", att_dm$type, level = 2)
      value <- convert(value, att_dm$type, att_dm$class.arg)}

    # -- output summary (debug)
    catl(">> Output: class =", class(value), "/ value =", as.character(value))

    # -- return
    value

  }


  # ////////////////////////////////////////////////////////////////////////////
  # -- check values & types

  as.data.frame(
    sapply(names(values),
           function(x) helper(key = x,
                              value = values[[x]],
                              att_dm = data.model[data.model$name == x, ]),
           simplify = FALSE,
           USE.NAMES = TRUE))

}
