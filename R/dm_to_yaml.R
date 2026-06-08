

#' Data Model To YAML
#'
#' @description
#' Convert data model to YAML configuration file.
#'
#' @param dm a data.frame of the data model
#'
#' @details
#' The input data model should have its version = "0.8.0" otherwise an error
#' will be raised. Use `dm_migrate()` first it needed.
#'
#' @returns a list
#' @export
#'
#' @examples
#' \notrun{
#' dm_to_yaml(dm, name = "my_item")
#' }

dm_to_yaml <- function(dm){

  # -- checks
  stopifnot("dm should be a data.frame object" = is.data.frame(dm))
  stopifnot("data model version must be 0.8.0, use dm_migrate first" = identical(attr(dm, "version"), "0.8.0"))

  # -- init
  yaml <- list()

  # ////////////////////////////////////////////////////////////////////////////
  # display, skip, refresh & sort

  # -- extract
  display <- setNames(dm$display, dm$name)
  skip <- setNames(dm$skip, dm$name)
  refresh <- setNames(dm$refresh, dm$name)
  sort_rank <- setNames(dm$sort.rank, dm$name)
  sort_desc <- setNames(dm$sort.desc, dm$name)

  # -- drop
  dm[c("display", "skip", "refresh", "sort.rank", "sort.desc")] <- NULL


  # ////////////////////////////////////////////////////////////////////////////
  # attributes

  attributes <- apply(dm, MARGIN = 1, function(x) {

    # -- mandatory elements
    attribute <- list(name = x['name'],
                      type = x['type'])

    # -- optional elements
    if(!is.na(x['class.arg']))
      attribute <- c(attribute, list(format = x['class.arg']))
    if(!is.na(x['values']))
      attribute <- c(attribute, list(values = x['values']))
    if(!is.na(x['default']))
      attribute <- c(attribute, list(default = x['default']))

    # -- return attribute
    attribute

  })

  # -- reset names
  names(attributes) <- NULL

  # -- append to yaml
  yaml <- c(yaml, list(attributes = attributes))


  # ////////////////////////////////////////////////////////////////////////////
  # display

  if(any(!display)){

    # -- attributes to hide or show (shortest list)
    x <- if(sum(display) / length(display) >= 0.5)
      list(hide = names(display)[!display])
    else
      list(show = names(display)[display])

    # -- append
    yaml <- c(yaml, x)}


  # ////////////////////////////////////////////////////////////////////////////
  # skip & refresh

  if(any(skip))
    yaml <- c(yaml, list(skip = names(skip)[skip]))

  if(any(refresh))
    yaml <- c(yaml, list(refresh = names(refresh)[refresh]))


  # ////////////////////////////////////////////////////////////////////////////
  # sort.rank & sort.desc

  if(any(!is.na(sort_rank))){

    # -- get attribute names, order & apply desc
    x <- names(sort(sort_rank[!is.na(sort_rank)]))
    x[x %in% names(which(sort_desc))] <- paste0("desc(", x[x %in% names(which(sort_desc))], ")")

    # -- append
    yaml <- c(yaml, list(sort = x))}


  # ////////////////////////////////////////////////////////////////////////////
  # return
  yaml

}
