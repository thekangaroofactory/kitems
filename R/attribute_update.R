

#' Update data model attribute
#'
#' @param data.model a data.frame containing the data model
#' @param name a character string of the attribute name
#' @param default.val a character string, the new default value
#' @param default.fun a character string, the new default function name
#' @param default.arg an optional named vector of arguments, to pass along with the default function.
#' @param skip a logical to set the skip value
#' @param display a logical to set the display value
#' @param sort.rank a numeric, used to define sort rank
#' @param sort.desc a logical, to define if sorting should be in descending order
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
#' @seealso [data_model()]
#'
#' @examples
#' \dontrun{
#' #Use of vector to update several attributes:
#' attribute_update(data.model = dm,
#'                  name = c("name","total"),
#'                  default.val = c("test", 2),
#'                  default.fun = NULL,
#'                  default.arg = NULL,
#'                  skip = TRUE)
#' }


attribute_update <- function(data.model, name,
                             default.val = NULL, default.fun = NULL, default.arg = NULL,
                             skip = NULL, display = NULL,
                             sort.rank = NULL, sort.desc = NULL){

  # -- update row
  # adding tests to update only if not NULL #226
  if(!is.null(default.val)){
    data.model[match(name, data.model$name), ]$default.val <- default.val
    data.model[match(name, data.model$name), ]$default.fun <- NA
    data.model[match(name, data.model$name), ]$default.arg <- NA}

  if(!is.null(default.fun)){
    data.model[match(name, data.model$name), ]$default.fun <- default.fun
    data.model[match(name, data.model$name), ]$default.val <- NA}

  if(!is.null(default.arg) & !is.null(default.fun))
    data.model[match(name, data.model$name), ]$default.arg <- default.arg

  if(!is.null(skip))
    data.model[match(name, data.model$name), ]$skip <- skip

  if(!is.null(display))
    data.model[match(name, data.model$name), ]$display <- display

  if(!is.null(sort.rank))
    data.model[match(name, data.model$name), ]$sort.rank <- sort.rank

  if(!is.null(sort.desc))
    data.model[match(name, data.model$name), ]$sort.desc <- sort.desc

  # -- return
  data.model

}
