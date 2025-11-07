

#' Module server
#'
#' @param id the id to be used for the module server instance
#' @param path a path where data model and items will be stored
#' @param autosave a logical whether the item auto save should be activated or not (default = TRUE)
#' @param admin a logical indicating if the admin module server should be launched (default = FALSE)
#' @param options a list of options (see details)
#' @param trigger a reactive object to pass events to the module (see details)
#'
#' @import shiny shinydashboard shinyWidgets
#' @importFrom ktools catl
#' @export
#'
#' @returns the module server returns a list of the references that are accessible outside the module.
#' All except id & url are references to reactive values.
#' list(id, url, items, data_model, filtered_items, selected_items, clicked_column, filter_date,
#' triggers = list(update))
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
#' Behavior of the module server can be tuned using a list of options
#' shortcut option is a logical to activate shortcut mechanism within item forms
#'
#' Triggers are the way to send events for the module to execute dedicated actions.
#' trigger must be a reactive (or NULL, the default). An event is defined as a named list of the form
#' list(workflow = "create", type = "dialog") or list(workflow = "create", type = "task", values = list(...))
#' If NULL, the trigger manager observer will not be initialized.
#'
#' @examples
#' \dontrun{
#' kitems(id = "mydata", path = "path/to/my/data", autosave = TRUE)
#' }


# -- Shiny module server logic -------------------------------------------------

kitems <- function(id, path, autosave = TRUE, admin = FALSE, trigger = NULL, options = list(shortcut = FALSE)) {

  moduleServer(id, function(input, output, session) {

    # //////////////////////////////////////////////////////////////////////////
    # -- Check parameters ----

    # -- check autosave & admin
    stopifnot("autosave argument must be a logical" = is.logical(autosave))
    stopifnot("admin argument must be a logical" = is.logical(admin))


    # -- check trigger
    if(!is.null(trigger))
      stopifnot("trigger must be a reactive object" = is.reactive(trigger))


    # -- check options
    stopifnot("options argument must be a list" = is.list(options))

    # -- helper: most probably expected to go into {ktools}
    helper <- function(fun, arg, value){
      def_val <- eval(formals(fun)[[arg]])
      missing <- def_val[!names(def_val) %in% names(value)]
      value <- value[names(value) %in% names(def_val)]
      c(value, missing)}

    # -- check elements in option list
    options <- helper(fun = kitems, arg = "options", value = options)
    stopifnot("shortcut option must be a logical" = is.logical(options$shortcut))


    # //////////////////////////////////////////////////////////////////////////
    # -- Init environment ----

    ## -- Declare config parameters ----

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    catl(MODULE, "Starting kitems module server...", debug = 1)

    # -- Get namespace
    ns <- session$ns


    ## -- Declare reactive objects ----

    # -- Internal create workflow triggers
    trigger_create_dialog <- reactiveVal(NULL)
    trigger_create_values <- reactiveVal(NULL)

    # -- Internal update workflow triggers
    trigger_update_dialog <- reactiveVal(NULL)
    trigger_update_values <- reactiveVal(NULL)

    # -- Internal delete workflow triggers
    trigger_delete_dialog <- reactiveVal(NULL)
    trigger_delete_values <- reactiveVal(NULL)


    # //////////////////////////////////////////////////////////////////////////
    # -- Initialize data model and items ----

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
        init_items <- item_load(col.classes = dm_colClasses(init_dm),
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
          init_items <- item_load(col.classes = dm_colClasses(init_dm),
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


    # //////////////////////////////////////////////////////////////////////////
    # -- Auto save ----

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


    # //////////////////////////////////////////////////////////////////////////
    # -- Item workflows ----

    ## -- declare shortcut observer ----
    if(options$shortcut)
      observeEvent(input$shortcut_trigger,
                   attribute_input_update(k_data_model(), input$shortcut_trigger, MODULE))


    # //////////////////////////////////////////////////////////////////////////
    ## -- Event manager (trigger) ----

    if(!is.null(trigger))
      event_manager <- observe({

        # -- get event & check
        event <- trigger()
        stopifnot("Event should be a list object" = is.list(event))
        stopifnot("Event should contain workflow & type named elements" = all(c("workflow", "type") %in% names(event)))
        catl(MODULE, "[Event] New event received, workflow =", event$workflow, "/ type =", event$type, "\n")

        # -- fire listeners
        if(event$workflow == "create" && event$type == "dialog")
          trigger_create_dialog(ifelse(is.null(trigger_create_dialog()), 0, trigger_create_dialog()) + 1)

        if(event$workflow == "create" && event$type == "task")
          trigger_create_values(event$values)

        if(event$workflow == "update" && event$type == "dialog")
          trigger_update_dialog(event$values$id)

        if(event$workflow == "update" && event$type == "task")
          trigger_update_values(event$values)

        if(event$workflow == "delete" && event$type == "dialog")
          trigger_delete_dialog(event$values)

        if(event$workflow == "delete" && event$type == "task")
          trigger_delete_values(event$values)

      }) |> bindEvent(trigger(),
                      ignoreInit = TRUE)


    # //////////////////////////////////////////////////////////////////////////
    ## -- Create item workflow ----

    # -- Declare: actionButton output
    output$item_create_btn <- renderUI(

      # -- Check data model #290
      if(!is.null(k_data_model()))
        actionButton(inputId = ns("item_create"),
                     label = "Create"))


    # -- Observe: fire dialog from UI
    observeEvent(input$item_create, {

      catl(MODULE, "[Event] Create item button")

      # -- show create dialog
      showModal(
        item_dialog(data.model = k_data_model(),
                    items = k_items(),
                    shortcut = options$shortcut,
                    ns = ns))})


    # -- Observe: fire dialog from trigger
    if(!is.null(trigger))
      observe({

        catl(MODULE, "[Event] Create item dialog trigger")

        # -- show create dialog
        showModal(
          item_dialog(data.model = k_data_model(),
                      items = k_items(),
                      shortcut = options$shortcut,
                      ns = ns))

      }) |> bindEvent(trigger_create_dialog())


    # -- Observe: create item from dialog values
    observeEvent(input$item_create_confirm, {

      catl(MODULE, "[Event] Confirm create dialog item")
      removeModal()

      # -- get named list of input values
      catl("- Get list of input values")
      values <- item_input_values(input, dm_colClasses(k_data_model()))

      # -- Secure workflow
      tryCatch({

        # -- store new item table
        k_items(
          rows_insert(items = k_items(),
                      values = values,
                      data.model = k_data_model()))

        # -- notify
        if(shiny::isRunning())
          showNotification(paste(MODULE, "Item created."), type = "message")

      },

      # -- failed
      error = function(e) {

        # -- print & notify
        warning(paste("Item has not been created. \n error =", e$message))
        if(shiny::isRunning())
          showNotification(paste(MODULE, "Item has not been created."), type = "error")

      })

    })


    # -- Observe: create item from trigger values
    if(!is.null(trigger))
      observe({

        catl(MODULE, "[Event] Create item(s) trigger")

        # -- Secure against errors
        tryCatch({

          # -- store new item table
          k_items(
            rows_insert(items = k_items(),
                        values = trigger_create_values(),
                        data.model = k_data_model()))

          # -- notify
          catl(MODULE, "Item(s) created")},

          # -- failed
          error = function(e) {

            # -- notify
            warning(paste("Item(s) not created. \n error =", e$message))

          })

        # -- reset trigger values
        # otherwise you can't create same object twice
        trigger_create_values(NULL)

      }) |> bindEvent(trigger_create_values(),
                      ignoreInit = TRUE)


    # //////////////////////////////////////////////////////////////////////////
    ## -- Update item workflow ----

    # -- Declare: actionButton output
    output$item_update_btn <- renderUI(

      # -- check item selection + single row
      if(is.null(input$filtered_view_rows_selected) | length(input$filtered_view_rows_selected) != 1)
        NULL
      else
        actionButton(inputId = ns("item_update"),
                     label = "Update"))


    # -- Observe: fire update dialog from UI
    observeEvent(input$item_update, {

      catl(MODULE, "[Event] Update item button")

      # -- Get selected item
      item <- k_items()[k_items()$id == selected_items(), ]

      # -- show update dialog
      showModal(
        item_dialog(data.model = k_data_model(),
                    items = k_items(),
                    workflow = "update",
                    item = item,
                    shortcut = options$shortcut,
                    ns = ns))})


    # -- Observe: fire update dialog from trigger
    if(!is.null(trigger))
      observe({

        catl(MODULE, "[Event] Update item dialog trigger")

        # -- Make sure value contains a single id
        req(length(trigger_update_dialog()) == 1)

        # -- Get selected item
        item <- k_items()[k_items()$id == trigger_update_dialog(), ]

        # -- show update dialog
        showModal(
          item_dialog(data.model = k_data_model(),
                      items = k_items(),
                      workflow = "update",
                      item = item,
                      shortcut = options$shortcut,
                      ns = ns))

      }) |> bindEvent(trigger_update_dialog(),
                      ignoreInit = TRUE)


    # -- Observe: update item from dialog
    observeEvent(input$item_update_confirm, {

      # -- close modal
      catl(MODULE, "[Event] Confirm update item button")
      removeModal()

      # -- get named list of input values
      catl("- Get list of input values")
      values <- item_input_values(input, dm_colClasses(k_data_model()))

      # -- force id to update
      # as it's missing in the dialog input, it should be NULL in values
      values$id <- if(!is.null(trigger_update_dialog()))
        trigger_update_dialog()
      else
        selected_items()

      # -- Secure against errors
      tryCatch({

        # -- store updated item list
        k_items(
          rows_update(items = k_items(),
                      values = values,
                      data.model = k_data_model()))

        # -- notify
        if(shiny::isRunning())
          showNotification(paste(MODULE, "Item updated."), type = "message")},

        # -- failed
        error = function(e) {

          # -- print & notify
          warning(paste("Item update has failed. \n error =", e$message))
          if(shiny::isRunning())
            showNotification(paste(MODULE, "Item has not been updated."), type = "error")

        })

      # -- reset trigger
      # otherwise same object cannot be updated twice
      # it can't be reset before otherwise id will be lost
      if(!is.null(trigger_update_dialog()))
        trigger_update_dialog(NULL)

    })


    # -- Observe: update item from trigger values
    if(!is.null(trigger))
      observe({

        # -- Secure against errors
        tryCatch({

          # -- store updated item list
          k_items(
            rows_update(items = k_items(),
                        values = trigger_update_values(),
                        data.model = k_data_model()))

          # -- notify
          catl(MODULE, "Item(s) updated")},

          # -- failed
          error = function(e)
            warning(paste("Item has not been updated. \n error =", e$message)))


        # -- reset values
        # otherwise you can't update same object twice
        trigger_update_values(NULL)

      }) |> bindEvent(trigger_update_values(),
                      ignoreInit = TRUE)


    # //////////////////////////////////////////////////////////////////////////
    ## -- Delete item workflow ----

    # -- Declare: actionButton output
    output$item_delete_btn <- renderUI(

      # -- check item selection
      if(is.null(input$filtered_view_rows_selected))
        NULL
      else
        actionButton(inputId = ns("item_delete"),
                     label = "Delete"))


    # -- Observe: fire dialog from actionButton
    observeEvent(input$item_delete, {

      catl(MODULE, "[Event] Delete item button")
      showModal(item_dialog(workflow = "delete", ns = ns))})


    # -- Observe: fire dialog from trigger
    if(!is.null(trigger))
      observe({

        catl(MODULE, "[Event] Delete item dialog trigger")
        showModal(item_dialog(workflow = "delete", ns = ns))

      }) |> bindEvent(trigger_delete_dialog(),
                      ignoreInit = TRUE)


    # -- Observe: delete item from actionButton
    observeEvent(input$item_delete_confirm, {

      catl(MODULE, "[Event] Confirm delete item(s) button")

      # -- close modal
      removeModal()

      # -- get selected items (ids)
      ids <- if(!is.null(trigger_delete_dialog()))
        trigger_delete_dialog()
      else
        selected_items()

      # -- Secure against errors
      tryCatch({

        # -- store new items table
        k_items(
          rows_delete(items = k_items(),
                      id = ids))

        if(shiny::isRunning())
          showNotification(paste(MODULE, "Item(s) deleted."), type = "message")},

        # -- failed
        error = function(e) {

          warning(paste("Item(s) has not been deleted. \n error =", e$message))
          if(shiny::isRunning())
            showNotification(paste(MODULE, "Item(s) not deleted."), type = "error")

        })

      # -- reset trigger
      # can't be performed before otherwise ids are lost
      if(!is.null(trigger_delete_dialog()))
        trigger_delete_dialog(NULL)

    })


    # -- Observe: delete item from trigger
    if(!is.null(trigger))
      observe({

        catl(MODULE, "[Event] delete item(s) trigger")

        # -- Secure against errors
        tryCatch({

          # -- store new items table
          k_items(
            rows_delete(items = k_items(),
                        id = trigger_delete_values()))

          if(shiny::isRunning())
            showNotification(paste(MODULE, "Item(s) deleted."), type = "message")},

          # -- failed
          error = function(e) {

            warning(paste("Item(s) has not been deleted. \n error =", e$message))
            if(shiny::isRunning())
              showNotification(paste(MODULE, "Item(s) not deleted."), type = "error")

          })

        # -- reset values
        # otherwise you can't update same object twice
        trigger_delete_values(NULL)

      }) |> bindEvent(trigger_delete_values(),
                      ignoreInit = TRUE)


    # //////////////////////////////////////////////////////////////////////////
    # -- Date slider ----

    ## -- Date slider ----
    observeEvent(input$date_slider_strategy, {

      # -- check data model
      req(hasDate(k_data_model()))

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
      updateSliderInput(inputId = "date_slider",
                        min = min,
                        max = max,
                        value = value)

    })


    ## -- Declare filter date ----
    filter_date <- reactive(

      # -- check data model (otherwise return NULL)
      if(hasDate(k_data_model())){

        catl(MODULE, "Date sliderInput has been updated")
        catl("- values =", input$date_slider, level = 2)

        # -- return
        input$date_slider})


    # //////////////////////////////////////////////////////////////////////////
    # -- Filtered items ----

    filtered_items <- reactive(

      # -- check
      # dependency on input (reactive) is disabled by bindEvent #483
      # otherwise it would fire update too many times
      if("date_slider" %in% names(input)){
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

        } else NULL
      } else k_items()) |> bindEvent(filter_date(), k_items(), k_data_model())


    # //////////////////////////////////////////////////////////////////////////
    # -- Filtered view ----

    ## -- Declare view ----
    output$filtered_view <- DT::renderDT(item_mask(k_data_model(), filtered_items()),
                                        rownames = FALSE,
                                        selection = list(mode = 'multiple', target = "row", selected = NULL))


    # //////////////////////////////////////////////////////////////////////////
    # -- In table selection ----

    ## -- Declare selected items ----
    selected_items <- reactive(
      filtered_items()[input$filtered_view_rows_selected, ]$id)


    ## -- Declare clicked column ----
    clicked_column <- reactive({

      # -- Get table col names
      # need to apply masks to get correct columns, hence sending only first row
      cols <- colnames(item_mask(k_data_model(), utils::head(filtered_items(), n = 1)))

      # -- Get name of the clicked column
      col_clicked <- cols[input$filtered_view_cell_clicked$col + 1]
      catl(MODULE, "Clicked column =", col_clicked, level = 2)

      # -- return
      col_clicked

    })


    # //////////////////////////////////////////////////////////////////////////
    # -- Admin ----

    # -- Call module
    if(admin)
      kitems_admin(k_data_model, k_items, path, dm_url, items_url, autosave)


    # //////////////////////////////////////////////////////////////////////////
    # -- Module server return value ----

    # -- the reference (not the value!)
    list(id = id,
         url = items_url,
         items = reactive(k_items()),
         data_model = reactive(k_data_model()),
         filtered_items = filtered_items,
         selected_items = selected_items,
         clicked_column = clicked_column,
         filter_date = filter_date)

  })
}

