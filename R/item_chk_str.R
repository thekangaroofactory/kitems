

#' Check Item Structure
#'
#' @param items the data.frame of the items
#' @param item the item to be tested
#'
#' @return either TRUE or an error
#'
#' @details
#' The function does not check the item vs the data model as it is used internally
#' during item creation or update (data model is not available in this context)
#'
#' @examples
#' \dontrun{
#' item_chk_str(items, item)
#' }

item_chk_str <- function(items, item){

  # -- check item structure #345
  ifelse(
    ncol(item) != ncol(items),
    stop("different column numbers"),

    # -- check column names
    ifelse(
      any(names(item) != names(items)),
      stop("different column names"),

      # -- check column classes
      ifelse(
        !all(lapply(items, class) %in% lapply(item, class)),
        stop("different column types"),

        # -- all checks passed (dummy return to avoid error)
        TRUE)))

}
