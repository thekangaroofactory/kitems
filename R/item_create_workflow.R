

#' Item Create Workflow
#'
#' @param items a data.frame of the existing items
#' @param data.model a data.frame of the data model
#' @param values a list or data.frame of values to create new item(s)
#' @param module an optional string to prefix notifications
#'
#' @returns the new data.frame of the items
#'
#' @examples
#' \dontrun{
#' item_create_workflow(items, data.model, values)
#' }

item_create_workflow <- function(items, data.model, values, module = ""){

  # -- Secure workflow
  tryCatch({

    # -- create item
    catl("- create item(s)")
    item <- item_create(values, data.model)

    # -- add to items & store
    catl("- add to existing items")
    items_new <- item_add(items, item)

    # -- notify
    if(shiny::isRunning())
      showNotification(paste(module, "Item created."), type = "message")

    # -- return
    items_new

  },

  # -- failed
  error = function(e) {

    # -- compute message
    msg <- paste("Item(s) creation failed. \n error =", e$message)

    # -- notify
    warning(msg)
    if(shiny::isRunning())
      showNotification(paste(module, msg), type = "error")

    # -- return
    items

  })

}
