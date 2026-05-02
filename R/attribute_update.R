

#' Update Attribute
#'
#' @description
#' Update data model attribute(s)
#'
#' @param data.model a data.frame of the data model
#' @param name the name(s) of the attribute(s) to update (see details)
#' @param class.arg the argument(s) to pass along with the class function
#' @param default the new default value(s)
#' @param display a logical to set display
#' @param skip a logical to set skip
#' @param refresh a logical to tell if skipped attributes should be refreshed upon update
#' @param sort.rank a named vector of integer(s), used to define sort rank
#' @param sort.desc a named vector of logical(s), to define if sorting should be in descending order
#'
#' @return The updated data.model
#' @export
#'
#' @details
#' Updating attribute class is not supported (as it requires data migration).
#'
#' Partial update will be performed based on arguments that are not NULL.
#'
#' The use of vectors to update several attributes is supported as long as the `length()` of the different
#' parameters is either same as `name` or 1 (then all rows gets same value).
#' When the intend is to update all attributes with the same value, then named vector is not necessary.
#'
#' When attribute parameters are not compatible, they will be reset.
#'
#' Otherwise same rules apply as in the `data_model()` function.
#'
#' @seealso [data_model()]
#'
#' @examples
#'
#' # -- define dm
#' dm <- data_model(colClasses = c(name = "character", total = "numeric"))
#'
#' # -- Use of vectors to update several attributes
#' attribute_update(data.model = dm,
#'                  name = c("name", "total"),
#'                  default = c(name = "test", total = 2),
#'                  skip = TRUE)
#'

attribute_update <- function(data.model, name, class.arg = NULL,
                             default = NULL,
                             display = NULL, skip = NULL, refresh = NULL,
                             sort.rank = NULL, sort.desc = NULL){

  # -- checks
  if(!all(name %in% data.model$name))
    stop(name[!name %in% data.model$name], "not an attribute of the data model")

  # -- init
  # saving input for conditional return
  x <- data.model
  colClasses <- dm_colClasses(data.model)

  # -- class.arg
  if(!is.null(class.arg)){
    class.arg <- match_arg_t1(class.arg, colClasses['class.arg'], mode = "character")
    x[match(name, x$name), ]$class.arg <- if(isTruthy(class.arg)) class.arg else NA}


  # ////////////////////////////////////////////////////////////////////////////

  # -- default
  if(!is.null(default)){
    default <- match_arg_t1(default, colClasses['default'])
    x[match(name, x$name), ]$default <- if(isTruthy(default)) as.character(default) else NA}


  # ////////////////////////////////////////////////////////////////////////////

  # -- display
  if(!is.null(display)){
    display <- match_arg_t2(display, default = TRUE, advice = "hide or show")
    x[match(name, x$name), ]$display <- display}

  # -- skip
  # note: reset refresh if needed
  if(!is.null(skip)){
    skip <- match_arg_t2(skip, advice = "skip")
    x[match(name, x$name), ]$skip <- skip
    # -- reset refresh
    idx <- x$name %in% name & !x$skip & x$refresh
    if(any(idx))
      x[idx, ]$refresh <- FALSE}

  # -- refresh
  # note: it's forbidden to refresh id (throwing an error so there's a cost
  # trying dummy stuff)
  if(!is.null(refresh)){
    if("id" %in% name) stop("It's forbidden to refresh the id attribute")
    x[match(name, x$name), ]$refresh <- if(skip) match_arg_t2(refresh, advice = "skip") else FALSE}


  # ////////////////////////////////////////////////////////////////////////////

  # -- sort.rank
  # note: reset sort.desc if needed
  if(!is.null(sort.rank)){
    sort.rank <- match_arg_t1(sort.rank, colClasses['sort.rank'], mode = "integer")
    x[match(name, x$name), ]$sort.rank <- if(isTruthy(sort.rank)) as.numeric(sort.rank) else NA
    # -- reset sort.desc
    idx <- x$name %in% name & is.na(x$sort.rank) & !is.na(x$refresh)
    if(any(idx))
      x[idx, ]$refresh <- NA}

  # -- sort.desc
  if(!is.null(sort.desc)){
    sort.desc <- match_arg_t1(sort.desc, colClasses['sort.desc'], mode = "logical")
    x[match(name, x$name), ]$sort.desc <- if(is_truthy(sort.desc)) as.logical(sort.desc) else NA}


  # ////////////////////////////////////////////////////////////////////////////
  # Integrity check
  # note: at this point, no specific corruption use case identified
  if(!is.data.frame(x) | any(!names(DATA_MODEL_COLCLASSES) %in% colnames(x))){
    stop("Data model corruption detected!", "\n returning the input data.model")
    return(data.model)}

  # -- return
  x

}
