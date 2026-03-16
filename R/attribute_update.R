

#' Update Attribute
#'
#' @description
#' Update data model attribute(s)
#'
#' @param data.model a data.frame of the data model
#' @param name the name(s) of the attribute(s) to update (see details)
#' @param class.arg the argument(s) to pass along with the class function
#' @param default.val the new default value(s)
#' @param default.fun the new default function name(s)
#' @param default.arg the new argument(s), to pass along with the default function(s)
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
#' Ex: setting `default.val` will reset both `default.fun` & `default.arg`
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
#'                  default.val = c(name = "test", total = 2),
#'                  skip = TRUE)
#'

attribute_update <- function(data.model, name, class.arg = NULL,
                             default.val = NULL, default.fun = NULL, default.arg = NULL,
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

  # -- make sure default.val & default.fun are mutual exclusive
  # note: default.fun has priority over default.val
  if(!is.null(default.fun) && !is.null(default.val))
    default.val <- NULL

  # -- default.val
  # note: reset default.fun & default.arg
  if(!is.null(default.val)){
    default.val <- match_arg_t1(default.val, colClasses['default.val'])
    x[match(name, x$name), ]$default.val <- if(isTruthy(default.val)) as.character(default.val) else NA
    x[match(name, x$name), ]$default.fun <- NA
    x[match(name, x$name), ]$default.arg <- NA}

  # -- default.fun
  # note: reset default.val
  # + it's okay to update only the function & keep default.arg
  if(!is.null(default.fun)){
    default.fun <- match_arg_t1(default.fun, colClasses['default.fun'], mode = "character")
    x[match(name, x$name), ]$default.fun <- if(isTruthy(default.fun)) as.character(default.fun) else NA
    # -- check default.arg reset
    idx <- x$name %in% name & is.na(x$default.fun) & !is.na(x$default.arg)
    if(any(idx))
      x[idx, ]$default.arg <- NA
    # -- reset default.val
    x[match(name, x$name), ]$default.val <- NA}

  # -- default.arg
  # note: it's okay to keep default.fun, but it must be set
  if(!is.null(default.arg))
    if(all(!is.na(x[match(name, x$name), ]$default.fun))){
      default.arg <- match_arg_t1(default.arg, colClasses['default.arg'], mode = "character")
      x[match(name, x$name), ]$default.arg <- if(isTruthy(default.arg)) as.character(default.arg) else NA}


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
  if(!is.null(refresh))
    x[match(name, x$name), ]$refresh <- if(skip) match_arg_t2(refresh, advice = "skip") else FALSE


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
