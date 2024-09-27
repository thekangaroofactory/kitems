

#' Generate dynamic menuItem
#'
#' @param names a list of the data model names
#'
#' @return a sidebarMenu menuItem object with one menuSubItem per data model
#' @export
#'
#' @examples
#' \dontrun{
#' dynamic_sidebar(names = list("data", "data2"))
#' }


dynamic_sidebar <- function(names){

  # -- Helper: return sub item
  helper <- function(name){
    menuSubItem(text = name, tabName = name,
                icon = shiny::icon("angle-double-right"))}

  # -- Apply helper
  subitems <- lapply(names, FUN = helper)

  # -- Return sidebar
  sidebarMenu(
    menuItem(text = "Data models", subitems))

}
