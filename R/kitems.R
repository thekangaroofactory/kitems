

#' Module server
#'
#' @param id the id to be used for the module server instance
#' @param path a path where data model and items will be stored
#' @param autosave a logical whether the item auto save should be activated or not (default = TRUE)
#' @param admin a logical indicating if the admin module server should be launched (default = FALSE)
#' @param shortcut a logical should attribute shortcuts be computed when building the item form (default = FALSE)
#'
#' @import shiny shinydashboard shinyWidgets
#' @importFrom ktools catl
#' @export
#'
#' @returns the module server returns a list of the references that are accessible outside the module.
#' All except id & url are references to reactive values.
#' list(id, url, items, data_model, filtered_items, selected_items, clicked_column, filter_date)
#'
#' @details
#'
#' If autosave is FALSE, the item_save function should be used to make the data persistent.
#' To make the data model persistent, use \link[base]{saveRDS} function. The file name should be
#' consistent with the output of \link[kitems]{dm_name} function used with \code{id} plus .rds extension.
#'
#' When admin is FALSE, \link[kitems]{admin_widget} will return an 'empty' layout (tabs with no content)
#' \link[kitems]{dynamic_sidebar} is not affected by this parameter.
#' It is expected that those function will not be used when admin = FALSE.
#'
#' @examples
#' \dontrun{
#' kitems(id = "mydata", path = "path/to/my/data", autosave = TRUE)
#' }


# -- Shiny module server logic -------------------------------------------------

kitems <- function(id, path, autosave = TRUE, admin = FALSE, shortcut = FALSE) {

  moduleServer(id, function(input, output, session) {

    # __________________________________________________________________________
    # -- Init app environment --------------------------------------------------

    ## -- Declare config parameters ----

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    catl(MODULE, "Starting kitems module server...", debug = 1)

    # -- Get namespace
    ns <- session$ns


    ## -- Declare objects ----

    # -- Declare reactive objects (for external use)
    filtered_items <- reactiveVal(NULL)
    selected_items <- reactiveVal(NULL)
    clicked_column <- reactiveVal(NULL)
    filter_date <- reactiveVal(NULL)


    # __________________________________________________________________________
    # -- Initialize data model and items ---------------------------------------

    # -- Notify progress
    withProgress(message = MODULE, value = 0, {

      ## -- Check path ---------------------------------------------------------
      incProgress(0/4, detail = "Init")

      # -- Build url from module id
      dm_url <- file.path(path, paste0(dm_name(id), ".rds"))
      items_url <- file.path(path, paste0(items_name(id), ".csv"))

      # -- Check folder structure
      # item files are stored in a dedicated folder #356
      if(basename(path) != id){

        # -- update path
        path <- file.path(path, id)
        catl(MODULE, "Update path =", path)

        # -- check updated path
        if(!dir.exists(path))
          dir.create(path)

        # -- Build new url
        new_dm_url <- file.path(path, paste0(dm_name(id), ".rds"))
        new_items_url <- file.path(path, paste0(items_name(id), ".csv"))

        # -- check for dm migration
        if(file.exists(dm_url)){
          catl(MODULE, "Moving data model file to updated path", debug = 1)
          res <- file.copy(dm_url, new_dm_url, overwrite = FALSE, copy.date = TRUE)
          if(res) unlink(dm_url) else warning("Copy failed, check folder")}

        # -- check for items migration
        if(file.exists(items_url)){
          catl(MODULE, "Moving items file to updated path", debug = 1)
          res <- file.copy(items_url, new_items_url, overwrite = FALSE, copy.date = TRUE)
          if(res) unlink(items_url) else warning("Copy failed, check folder")}

        # -- Update url & cleanup
        dm_url <- new_dm_url
        items_url <- new_items_url
        rm(new_dm_url, new_items_url)

      } else {

        # -- Create path (to avoid connection problems if missing folder)
        if(!dir.exists(path))
          dir.create(path)}


      ## -- Read data model ----------------------------------------------------

      # -- Init (non persistent object)
      init_dm <- NULL

      catl(MODULE, "Checking if data model file exists")
      catl("- path =", dirname(dm_url), level = 2)
      catl("- file =", basename(dm_url), level = 2)

      # -- Check url
      if(file.exists(dm_url)){

        catl(MODULE, "Reading data model from file")
        init_dm <- readRDS(dm_url)
        catl("- output dim =", dim(init_dm))

      } else {

        catl(">> No data model file found.")

        }

      # -- Increment the progress bar, and update the detail text.
      incProgress(1/4, detail = "Read data model")


      # -- Read the data (items) ----------------------------------------------

      # -- Init (non persistent object)
      init_items <- NULL

      # -- Check for NULL data model (then no reason to try loading)
      if(!is.null(init_dm))

        # path = NULL as temporary workaround (it's contained in items_url)
        init_items <- item_load(data.model = init_dm,
                                file = items_url,
                                path = NULL)

      # -- Increment the progress bar, and update the detail text.
      incProgress(2/4, detail = "Read items")


      # -- Check data model integrity -----------------------------------------

      # -- Check for NULL data model + data.frame
      if(!is.null(init_dm) & !is.null(init_items)){

        catl(MODULE, "Checking data model integrity")
        result <- dm_integrity(data.model = init_dm, items = init_items, template = TEMPLATE_DATA_MODEL)

        # -- Check feedback (otherwise value is TRUE)
        if(is.data.frame(result)){

          # -- Update data model & save
          init_dm <- result
          if(autosave){
            saveRDS(init_dm, file = dm_url)
            catl(MODULE, "Data model saved")}

          # -- Reload data with updated data model
          # path = NULL as temporary workaround (it's contained in items_url)
          catl(MODULE, "Reloading the item data with updated data model")
          init_items <- item_load(data.model = init_dm,
                                  file = items_url,
                                  path = NULL)

        }}


      # -- Check items integrity -----------------------------------------------

      # -- Check classes vs data.model
      if(!is.null(init_dm) & !is.null(init_items)){

        catl(MODULE, "Checking items classes integrity")
        init_items <- item_integrity(items = init_items,
                                     data.model = init_dm)}

      # Increment the progress bar, and update the detail text.
      incProgress(3/4, detail = "Integrity checked")


      # -- Store into reactive values ------------------------------------------

      # -- Store data model (either content of the RDS or the server function input)
      k_data_model <- reactiveVal(init_dm)
      rm(init_dm)

      # -- Store items
      k_items <- reactiveVal(init_items)
      rm(init_items)

      # Increment the progress bar, and update the detail text.
      incProgress(4/4, detail = "Load data done")

    }) #end withProgress


    # __________________________________________________________________________
    # -- Auto save -------------------------------------------------------------

    ## -- Data model ----

    # -- Check parameter & observe data model
    if(autosave)
      observeEvent(k_data_model(), {

        # -- Write & notify
        saveRDS(k_data_model(), file = dm_url)
        catl(MODULE, "[EVENT] Data model has been (auto) saved")

      }, ignoreInit = TRUE)


    ## -- Items ----

    # -- Check parameter & observe items
    if(autosave)
      observeEvent(k_items(), {

        # -- Write
        item_save(data = k_items(), file = items_url)

        # -- Notify
        catl(MODULE, "[EVENT] Item list has been (auto) saved")

      }, ignoreInit = TRUE)


    # __________________________________________________________________________
    # -- Item management ----
    # __________________________________________________________________________

    ## -- declare shortcut observer ----
    if(shortcut)
      observeEvent(input$shortcut_trigger,
                   attribute_input_update(k_data_model, input$shortcut_trigger, MODULE))


    # __________________________________________________________________________
    ## -- Create item ----
    # __________________________________________________________________________

    # -- Declare: output
    output$item_create <- renderUI(

      # -- Check data model #290
      if(!is.null(k_data_model()))
        actionButton(inputId = ns("item_create"),
                     label = "Create"))


    # -- Observe: actionButton
    observeEvent(input$item_create, {

                 catl(MODULE, "[BTN] Create item")

                 showModal(modalDialog(
                   item_form(data.model = k_data_model(),
                             items = k_items(),
                             update = FALSE,
                             item = NULL,
                             shortcut = shortcut,
                             ns = ns),
                   title = "Create",
                   footer = tagList(
                     modalButton("Cancel"),
                     actionButton(ns("item_create_confirm"), "Create"))))

    })


    # -- Observe: actionButton
    observeEvent(input$item_create_confirm, {

      catl(MODULE, "[BTN] Confirm create item")

      # -- close modal
      removeModal()

      # -- get list of input values & name it
      catl("- Get list of input values")
      item_input_values <- item_input_values(input, dm_colClasses(k_data_model()))

      # -- create item based on input list
      catl("- Create item")
      item <- item_create(values = item_input_values, data.model = k_data_model())

      # -- Secure against errors raised by item_add #351
      tryCatch({

        # -- add to items & update reactive
        k_items(item_add(k_items(), item))

        # -- prepare notify
        msg <- "Item created."
        type <- "message"},

        # -- failed
        error = function(e) {

          # -- prepare notify
          msg <- paste("Item has not been created. \n error =", e$message)
          type <- "error"

          # -- return
          message(msg)},

        # -- notify
        finally = if(shiny::isRunning())
          showNotification(paste(MODULE, msg), type))

    })


    # __________________________________________________________________________
    ## -- Update item ----
    # __________________________________________________________________________

    # -- Declare: output
    output$item_update <- renderUI(

      # -- check item selection + single row
      if(is.null(selected_items()) | length(selected_items()) != 1)
        NULL
      else
        actionButton(inputId = ns("item_update"),
                     label = "Update"))


    # -- Observe: actionButton
    observeEvent(input$item_update, {

      catl(MODULE, "[BTN] Update item")

      # -- Get selected item
      item <- k_items()[k_items()$id == selected_items(), ]

      # -- Dialog
      showModal(modalDialog(item_form(data.model = k_data_model(),
                                      items = k_items(),
                                      update = TRUE,
                                      item = item,
                                      shortcut = shortcut,
                                      ns = ns),
                            title = "Update",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("item_update_confirm"), "Update"))))

    })

    # -- Observe: actionButton
    observeEvent(input$item_update_confirm, {

      catl(MODULE, "[BTN] Confirm update item")

      # -- close modal
      removeModal()

      # -- get list of input values & name it
      catl("- Get list of input values")
      item_input_values <- item_input_values(input, dm_colClasses(k_data_model()))

      # -- update id (to replace selected item)
      item_input_values$id <- selected_items()

      # -- create item based on input list
      catl("- Create replacement item")
      item <- item_create(values = item_input_values, data.model = k_data_model())

      # -- Secure against errors raised by item_add #351
      tryCatch({

        # -- update item & reactive
        k_items(item_update(k_items(), item))

        # -- prepare notify
        msg <- "Item updated."
        type <- "message"},

        # -- failed
        error = function(e) {

          # -- prepare notify
          msg <- paste("Item has not been updated. \n error =", e$message)
          type <- "error"

          # -- return
          message(msg)},

        # -- notify
        finally = if(shiny::isRunning())
          showNotification(paste(MODULE, msg), type))

    })


    # __________________________________________________________________________
    ## -- Delete item(s) ----
    # __________________________________________________________________________

    # -- Declare: output
    output$item_delete <- renderUI(

      # -- check item selection
      if(is.null(selected_items()))
        NULL
      else
        actionButton(inputId = ns("item_delete"),
                     label = "Delete"))


    # -- Observe: actionButton
    observeEvent(input$item_delete, {

      catl(MODULE, "[BTN] Delete item")

      # -- Open dialog for confirmation
      showModal(modalDialog(title = "Delete item(s)",
                            "Danger: deleting item(s) can't be undone! Do you confirm?",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("item_delete_confirm"), "Delete"))))

    })

    # -- Observe: actionButton
    observeEvent(input$item_delete_confirm, {

      catl(MODULE, "[BTN] Confirm delete item(s)")

      # -- close modal
      removeModal()

      # -- get selected items (ids)
      ids <- selected_items()
      catl("- Item(s) to be deleted =", as.character(ids))

      # -- Secure against errors raised by item_add #351
      tryCatch({

        # -- delete item & update reactive
        k_items(item_delete(k_items(), ids))

        # -- prepare notify
        msg <- "Item(s) deleted."
        type <- "message"},

        # -- failed
        error = function(e) {

          # -- prepare notify
          msg <- paste("Item(s) has not been deleted. \n error =", e$message)
          type <- "error"

          # -- return
          message(msg)},

        # -- notify
        finally = if(shiny::isRunning())
          showNotification(paste(MODULE, msg), type))

    })


    # __________________________________________________________________________
    # -- Date slider -----------------------------------------------------------

    ## -- Date slider strategy ----
    output$date_slider_strategy <- renderUI(

      # -- check data model
      if(hasDate(k_data_model()))
        radioButtons(inputId = ns("date_slider_strategy"),
                     label = "Strategy",
                     choices = c("this-year", "keep-range"),
                     selected = "this-year",
                     inline = TRUE)
      else NULL)


    ## -- Date slider ----
    output$date_slider <- renderUI({

      # -- check data model
      if(hasDate(k_data_model()) & !is.null(input$date_slider_strategy)){

        catl(MODULE, "Building date sliderInput")
        catl("- strategy =", input$date_slider_strategy)

        # -- Get min/max
        if(dim(k_items())[1] > 0){

          min <- min(k_items()$date)
          max <- max(k_items()$date)

        } else {

          min <- as.Date(Sys.Date())
          max <- min

        }

        # -- Set value
        # implement this_year strategy by default #211
        # keep this year after item is added #223 & #242
        value <- if(is.null(input$date_slider_strategy) || input$date_slider_strategy == "this-year")
          ktools::date_range(min, max, type = "this_year")
        else
          value <- filter_date()

        # -- date slider
        sliderInput(inputId = ns("date_slider"),
                    label = "Date",
                    min = min,
                    max = max,
                    value = value)

      } else {

        # -- cleanup after remove date attribute
        if(!is.null(filter_date()))
          filter_date(NULL)

        NULL}

    })


    ## -- Observe date_slider input ----
    observeEvent(input$date_slider, {

      catl(MODULE, "Date sliderInput has been updated")
      catl("- values =", input$date_slider, level = 2)

      # -- store
      filter_date(input$date_slider)

    })


    # __________________________________________________________________________
    # -- Filtered items --------------------------------------------------------

    ## -- Declare filtered_items ----
    observe(

      # -- update the reactiveVal
      filtered_items(

        # -- check
        if(!is.null(filter_date())){

          catl(MODULE, "Updating filtered item view")

          # -- init
          items <- k_items()
          dm <- k_data_model()

          # -- Apply date filter
          items <- items[items$date >= filter_date()[1] & items$date <= filter_date()[2], ]

          # -- Apply ordering
          if(any(!is.na(dm$sort.rank)))
            items <- item_sort(items, dm)

          catl("- ouput dim =", dim(items), level = 2)

          # -- Return
          items

        } else k_items()))


    ## -- Declare filtered_items ----
    # filtered_items <- reactive(
    #
    #   # -- check
    #   if(!is.null(filter_date())){
    #
    #     catl(MODULE, "Updating filtered item view")
    #
    #     # -- init
    #     items <- k_items()
    #     dm <- k_data_model()
    #
    #     # -- Apply date filter
    #     items <- items[items$date >= filter_date()[1] & items$date <= filter_date()[2], ]
    #
    #     # -- Apply ordering
    #     if(any(!is.na(dm$sort.rank)))
    #       items <- item_sort(items, dm)
    #
    #     catl("- ouput dim =", dim(items), level = 2)
    #
    #     # -- Return
    #     items
    #
    #   } else k_items()
    #
    # )


    ## -- Declare view ----
    output$filtered_view <- DT::renderDT(item_mask(k_data_model(), filtered_items()),
                                        rownames = FALSE,
                                        selection = list(mode = 'multiple', target = "row", selected = NULL))


    ## -- Manage in table selection ----

    ### -- Selected row / selected_items ----
    observeEvent(input$filtered_view_rows_selected, {

      # -- Setting ignoreNULL to FALSE + check to allow unselect all (then selected_items will be NULL)
      if(is.null(input$filtered_view_rows_selected))
        ids <- NULL

      else {

        catl(MODULE, "Selected rows (filtered view) =", input$filtered_view_rows_selected)

        # -- Get item ids from the default view
        ids <- filtered_items()[input$filtered_view_rows_selected, ]$id
        catl("- ids =", as.character(ids), level = 2)

      }

      # -- Store
      selected_items(ids)

    }, ignoreNULL = FALSE)


    ### -- Cell clicked / clicked_column ----
    observeEvent(input$filtered_view_cell_clicked$col, {

      # -- Get table col names (need to apply masks to get correct columns, hence sending only first row)
      cols <- colnames(item_mask(k_data_model(), utils::head(filtered_items(), n = 1)))

      # -- Get name of the clicked column
      col_clicked <- cols[input$filtered_view_cell_clicked$col + 1]
      catl(MODULE, "Clicked column (filtered view) =", col_clicked, level = 2)

      # -- Store
      clicked_column(col_clicked)

    }, ignoreNULL = TRUE)


    # __________________________________________________________________________
    # -- Admin ----
    # __________________________________________________________________________

    # -- Call module
    if(admin)
      kitems_admin(k_data_model, k_items, path, dm_url, items_url, autosave)


    # __________________________________________________________________________
    # -- Module server return value ----
    # __________________________________________________________________________

    # -- the reference (not the value!)
    list(id = id,
         url = items_url,
         items = k_items,
         data_model = k_data_model,
         filtered_items = filtered_items,
         selected_items = selected_items,
         clicked_column = clicked_column,
         filter_date = filter_date)

  })
}

