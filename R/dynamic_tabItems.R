

#' Title
#'
#' @param r
#'
#' @return
#' @export
#'
#' @examples

# ------------------------------------------------------------------------
# The function works but I can't ouput it in the tabitems UI
# everything gets display in the same tab...
# ------------------------------------------------------------------------


dynamic_tabItems <- function(r){

  # -- Get data model list
  dm_list <- dm_get_list(r = r)

  # -- Helper: return sub item
  helper <- function(name){
    tabItem(tabName = name,
            fluidRow(column(width = 12, admin_ui(name))))}

  # -- Apply helper & return
  tabs <- lapply(dm_list, FUN = helper)

}
