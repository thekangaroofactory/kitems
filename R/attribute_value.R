

#' Turn Value(s) into Attribute
#'
#' @param key the name of the attribute
#' @param value a vector of input values
#' @param data.model the data.frame of the data.model
#'
#' @returns a vector, with values checked against the data.model
#' @export
#'
#' @examples
#' \dontrun{
#' attribute_value(key, value, data.model)}

attribute_value <- function(key, value, data.model){

  # -- extract expected class from data.model
  colClass <- dm_colClasses(data.model)[key]

  # -- input summary (debug)
  catl("Process attribute: key =", key)
  catl("- input value =", as.character(value), level = 2)
  catl("- target class =", colClass, level = 2)


  # ////////////////////////////////////////////////////////////////////////////
  # -- Validate or replace input values

  # -- depends on single / multiple values
  if(length(value) <= 1){

    if(!is_truthy(value)){
      catl("> Attribute has invalid input / set default", level = 2)
      value <- dm_default(data.model, key)}

  } else {

    # -- get valid values
    is_valid <- sapply(value, is_truthy)

    # -- replace invalid ones by default
    if(any(!is_valid)){
      catl("> Attribute has invalid input(s) / set default", level = 2)
      value[!is_valid] <- dm_default(data.model, key, n = length(value[!is_valid]))}

  }

  # ////////////////////////////////////////////////////////////////////////////
  # -- check vs target class
  # value might have several classes (case POSIX*)
  if(!colClass %in% class(value)){
    catl("> Class:", class(value), "does not fit with:", colClass, "/ Coerce to target class", level = 2)
    value <- eval(call(CLASS_FUNCTIONS[[colClass]], value))}

  # -- output summary (debug)
  catl("> Output: class =", class(value), "/ value =", as.character(value))

  # -- return
  value

}
