

#' Update data model attribute
#'
#' @param data.model a data.frame containing the data model
#' @param name a character string of the attribute name
#' @param default.val the new default value (default = NULL)
#' @param default.fun a character string, the new default function name (default = NULL)
#' @param skip a logical to set the skip value (default = FALSE)
#'
#' @return the updated data model
#' @export
#'
#' @details
#' Updating attribute class is not supported by this function (as it requires data migration).
#'
#' Use of vector to update several attributes is supported as long as length of the different parameters
#' is either same as name or 1 (then all rows gets same value).
#'
#' Note that filter should be updated using dm_filter_set() function
#'
#' @examples
#' \dontrun{
#' #Use of vector to update several attributes:
#' dm_update_attribute(data.model = dm,
#'                     name = c("name","total"),
#'                     default.val = c("test", 2),
#'                     default.fun = NA,
#'                     skip = TRUE)
#' }


dm_update_attribute <- function(data.model, name, default.val = NULL, default.fun = NULL, skip = NULL){

  # -- make sure default.val & fun are mutual exclusive #229
  if(!is.null(default.fun))
    default.val <- NA
  else
    if(!is.null(default.val))
      default.fun <- NA

  # -- update row
  # removed filter: #225
  # adding tests to update only if not NULL #226
  if(!is.null(default.val))
    data.model[match(name, data.model$name), ]$default.val <- default.val

  if(!is.null(default.fun))
    data.model[match(name, data.model$name), ]$default.fun <- default.fun

  if(!is.null(skip))
    data.model[match(name, data.model$name), ]$skip <- skip

  # -- return
  data.model

}
