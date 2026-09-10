

#' Get Items
#'
#' @description
#' This function is part of the selective loading mechanism to ensure
#' items are loaded only when required.
#'
#' @param datamart a reactiveValues object holding the items
#' @param config the config list
#' @param item the name (id) of the item group
#'
#' @returns a data.frame of the items or NULL
#' @export
#'
#' @examples
#' \dontrun{
#' # init the datamart
#' datamart <- reactiveValues()
#'
#' # get items (it will load them)
#' datamart |> items("foo")
#'
#' # get them again (already loaded)
#' datamart |> items("foo")
#' }

items <- function(datamart, config, item){

  # -- secure param
  # also make it testable
  if(isRunning())
    stopifnot("datamart must be a reactiveValues object" = is.reactivevalues(datamart))
  else
    stopifnot("datamart must be a list object" = is.list(datamart))

  # -- check
  if(!item %in% names(datamart)){
    message("Selective loading is required for item ", crayon::blue(item))
    datamart$item <- item_load(connector = ci_connector(config, item),
                               col.classes = ci_classes(config, item))}

  # -- return
  datamart$item

}
