

#' Import Module Server
#'
#' @description
#' The import module server is used as a child of the admin module server.
#'
#' @param id the id of the module.
#' @param k_data_model the reference of the data model reactive.
#' @param k_items the reference of the items reactive.
#' @param callback a reactive to call once import is finished.
#'
#' @keywords internal
#'

import_server <- function(id, k_data_model, k_items, callback) {

  moduleServer(id, function(input, output, session) {

    # -- Init ------------------------------------------------------------------

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    catl(MODULE, "Starting import module server...")

    # -- Get namespace
    ns <- session$ns

    # -- Declare reactive values
    cache_items <- reactiveVal(NULL)
    cache_dm <- reactiveVal(NULL)


    # -- Chose file ------------------------------------------------------------
    # display modal
    showModal(modalDialog(fileInput(inputId = ns("file"),
                                    label = "Select file",
                                    multiple = FALSE,
                                    accept = ".csv",
                                    buttonLabel = "Browse...",
                                    placeholder = "No file selected"),
                          title = "Import data",
                          footer = tagList(
                            modalButton("Cancel"),
                            actionButton(ns("file_confirm"), "Next"))))


    # -- Build items -----------------------------------------------------------
    # Observe: actionButton
    session$userData$build_item_obs <- observeEvent(input$file_confirm, {

      # -- Check file input & close modal
      req(input$file)
      removeModal()

      # -- Load the data
      items <- iker::read_data(path = NULL,
                               file = input$file$datapath)

      # -- Check if dataset has id #208
      hasId <- "id" %in% colnames(items)

      # -- Store in cache
      cache_items(items)

      # -- Generate id(s)
      if(!hasId){

        catl(MODULE, "Dataset has no id column, creating one")

        # -- compute expected time (based on average time per id) #221
        n <- nrow(items)
        expected_time <- round(nrow(items) * 0.0156)

        # -- Display message has it can take a bit of time depending on dataset size
        showModal(modalDialog(p("Computing", n, "id(s) to import the dataset..."),
                              p("Expected time:", expected_time, "s"),
                              title = "Import data",
                              footer = NULL))

        # -- Compute a vector of ids (should be fixed by #214)
        catl(MODULE, "Generating id(s) ...", level = 2)
        fill <- ktools::seq_timestamp(n = n)

        # -- add attribute & reorder
        items <- item_migrate(items, name = "id", type = "numeric", fill = fill)
        items <- items[c("id", colnames(items)[!colnames(items) %in% "id"])]

        # -- update cache
        cache_items(items)

        # -- close modal
        removeModal()}

      # -- Display items preview
      # adding options to renderDT #207
      showModal(modalDialog(DT::renderDT(items, rownames = FALSE, options = list(scrollX = TRUE)),
                            # -- test: in case no id column exists #208
                            if(!hasId)
                              p("Note: the dataset had no id column, it has been generated automatically."),
                            title = "Import data",
                            size = "l",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("items_confirm"), "Next"))))

      }, ignoreInit = TRUE)


    # -- Build data model ------------------------------------------------------
    # -- Observe: actionButton
    session$userData$build_dm_obs <- observeEvent(input$items_confirm, {

      # -- Close modal
      removeModal()

      # -- Get the data model
      # use dm_integrity with data.model = NULL means all attributes are missing
      catl(MODULE, "Extract data model from data")
      dm <- dm_integrity(data.model = NULL, items = cache_items(), template = TEMPLATE_DATA_MODEL)

      # -- Store in cache
      cache_dm(dm)

      # -- Display data model preview
      # adding options to renderDT #207
      showModal(modalDialog(p("Data model built from the data:"),
                            DT::renderDT(dm, rownames = FALSE, options = list(scrollX = TRUE)),
                            title = "Import data",
                            size = "l",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("dm_confirm"), "Import"))))

      }, ignoreInit = TRUE)


    # -- Confirm import --------------------------------------------------------
    # -- Observe: actionButton
    session$userData$confirm_import_obs <- observeEvent(input$dm_confirm, {

      # -- Close modal
      removeModal()

      # -- Check items classes #216
      # Because dataset was read first, the current colclasses are 'guessed' and may not comply with the data model
      # ex: date class is forced in data model, but it may be char ("2024-02-07) or num (19760)
      items <- item_integrity(items = cache_items(), data.model = cache_dm())

      # -- Store items & data model
      k_items(items)
      k_data_model(cache_dm())

      # -- notify
      if(shiny::isRunning())
        showNotification(paste(MODULE, "Data imported."), type = "message")

      # -- update callback reactive
      callback(TRUE)

      }, ignoreInit = TRUE)


  }) # moduleServer
}
