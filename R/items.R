

#' Get Items
#'
#' @description
#' This function is part of the selective loading mechanism to ensure
#' items are loaded only when required.
#'
#' @param datamart a reactiveValues object holding the items
#' @param item the name (id) of the item to return
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

items <- function(datamart, item){

  # -- secure param
  stopifnot("datamart must be a reactiveValues object" = "reactiveValues" %in% class(datamart))

  # -- check
  if(!item %in% names(datamart)){
    message("Selective loading is required for item ", crayon::blue(item))
    datamart$item <- item_load(connector = config_item_connector(config(), item),
                               col.classes = config_item_colclasses(config(), item))}

  # -- return
  datamart$item

}
