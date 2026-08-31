

#' Validate Value(s)
#'
#' @description
#' Validate values and turn them into item(s)
#'
#' @param values a list of named values.
#' @param data.model the data.frame of the data model (see details).
#' @param update whether the id attribute should be checked or not (default FALSE).
#'
#' @details
#' This function does not accept the data.model element of the config list as an input.
#' It should be turned into a data.frame first, using [yaml_to_dm()].
#'
#' `data.model` should contain the following columns:
#' "name", "type", "default", "class.arg".
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

  # -- id is not checked upon update workflow #620
  cols <- if(update)
    names(values)[!names(values) == "id"]
  else
    names(values)

  # -- check values (loop over attributes)
  att_values <- sapply(cols,
                      function(x) helper(key = x,
                                         value = values[[x]],
                                         att_dm = data.model[data.model$name == x, ]),
                      simplify = FALSE,
                      USE.NAMES = TRUE)

  # -- return
  if(update)
    as.data.frame(c(values["id"], att_values))
  else
    as.data.frame(att_values)

}
