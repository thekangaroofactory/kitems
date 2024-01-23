

#' Generate dynamic menuItem
#'
#' @param r the reactive shared communication object
#'
#' @return a sidebarMenu menuItem object with one menuSubItem per data model
#' @export
#'
#' @examples
#' dynamic_sidebar(r)


dynamic_sidebar <- function(r){

  # -- Get data model list
  dm_list <- dm_get_list(r = r)

  # -- Helper: return sub item
  helper <- function(name){
    menuSubItem(text = name, tabName = name,
                icon = shiny::icon("angle-double-right"))}

  # -- Apply helper
  subitems <- lapply(dm_list, FUN = helper)

  # -- Return sidebar
  sidebarMenu(
    menuItem(text = "Data models", subitems))

}
