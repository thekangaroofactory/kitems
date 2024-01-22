

#' Title
#'
#' @param id
#' @param r
#' @param file
#' @param path
#' @param data.model
#' @param create
#' @param autosave
#'
#'
#' @details
#'
#'
#' @examples


# ------------------------------------------------------------------------------
# Shiny module server logic
# ------------------------------------------------------------------------------

kitemsManager_Server <- function(id, r, file, path,
                                 data.model = NULL,
                                 create = TRUE, autosave = TRUE) {
  moduleServer(id, function(input, output, session) {

    # --------------------------------------------------------------------------
    # Declare config parameters:
    # --------------------------------------------------------------------------

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")

    # -- Object types (supported)
    OBJECT_CLASS <- c("numeric",
                      "integer",
                      "double",
                      "logical",
                      "character",
                      "factor",
                      "Date",
                      "POSIXct",
                      "POSIXlt")

    # -- Default values
    DEFAULT_VALUES <- list("numeric" = c(NA, 0),
                           "integer" = c(NA, 0),
                           "double" = c(NA, 0),
                           "logical" = c(NA, FALSE, TRUE),
                           "character" = c(NA, ""),
                           "factor" = c(NA),
                           "Date" = c(NA),
                           "POSIXct" = c(NA),
                           "POSIXlt" = c(NA))

    # -- Default values
    DEFAULT_FUNCTIONS <- list("numeric" = c(NA),
                              "integer" = c(NA),
                              "double" = c(NA),
                              "logical" = c(NA),
                              "character" = c(NA),
                              "factor" = c(NA),
                              "Date" = c("Sys.Date"),
                              "POSIXct" = c("Sys.Date"),
                              "POSIXlt" = c("Sys.Date"))


    # --------------------------------------------------------------------------
    # Declare templates:
    # --------------------------------------------------------------------------

    # -- Data model template
    TEMPLATE_DATA_MODEL <- data.frame(name = c("date",
                                               "name", "title", "description", "comment", "note", "status", "detail",
                                               "debit", "credit", "amount", "total", "balance",
                                               "quantity", "progress"),
                                      type = c("Date",
                                               rep("character", 7),
                                               rep("double", 5),
                                               rep("integer", 2)))


    # --------------------------------------------------------------------------
    # Init:
    # --------------------------------------------------------------------------

    cat(MODULE, "Starting kitems module server... \n")

    # -- Get namespace
    ns <- session$ns

    # -- Check paths (to avoid connection problems if missing folder)
    missing_path <- path[!dir.exists(unlist(path))]
    result <- lapply(missing_path, dir.create)


    # -- Build filename from module id
    dm_url <- file.path(path$resource, paste0(dm_name(id), ".rds"))


    # -- Build object names from module id (to access outside module)
    r_data_model <- dm_name(id)
    r_items <- items_name(id)

    r_filtered_items <- filtered_items_name(id)

    r_selected_items <- selected_items_name(id)

    r_filter_date <- filter_date_name(id)


    # -- Declare reactive objects (for external use)
    r[[r_items]] <- reactiveVal(NULL)

    r[[r_filtered_items]] <- reactiveVal(NULL)

    r[[r_selected_items]] <- reactiveVal(NULL)

    r[[r_filter_date]] <- reactiveVal(NULL)

    # -- Declare date slider objects
    min_date <- reactiveVal(NULL)
    max_date <- reactiveVal(NULL)


    # --------------------------------------------------------------------------
    # Read data model:
    # --------------------------------------------------------------------------

    # -- Check url
    if(file.exists(dm_url)){

      data.model <- readRDS(dm_url)
      cat(MODULE, "Read data model done \n")}


    # --------------------------------------------------------------------------
    # Read the data (items):
    # --------------------------------------------------------------------------

    # -- Init
    items <- NULL

    # -- Check for NULL data model (then no reason to try loading)
    if(!is.null(data.model))

      items <- item_load(data.model = data.model,
                         file = file,
                         path = path,
                         create = create)


    # --------------------------------------------------------------------------
    # Check data model integrity:
    # --------------------------------------------------------------------------

    # -- Check for NULL data mode + data.frame
    if(!is.null(data.model) & !is.null(items)){

      result <- dm_check_integrity(data.model = data.model, items = items, template = TEMPLATE_DATA_MODEL)

      # -- Check feedback (otherwise value is TRUE)
      if(is.data.frame(result)){

        # -- Update data model & save
        data.model <- result
        saveRDS(data.model, file = dm_url)
        cat(MODULE, "Data model saved \n")

        # -- Reload data with updated data model
        cat(MODULE, "[Warning] Data model not synchronized with items data.frame! \n")
        cat(MODULE, "Reloading the item data with updated data model \n")

        items <- item_load(data.model = data.model,
                           file = file,
                           path = path,
                           create = create)

      }}


    # --------------------------------------------------------------------------
    # Store into reactive values:
    # --------------------------------------------------------------------------

    # -- Store data model (either content of the RDS or the server function input)
    r[[r_data_model]] <- reactiveVal(data.model)

    # -- Store items
    r[[r_items]]<- reactiveVal(items)


    # --------------------------------------------------------------------------
    # Auto save the data model:
    # --------------------------------------------------------------------------

    # -- Observe data model
    observeEvent(r[[r_data_model]](), {

      # -- Write & notify
      saveRDS(r[[r_data_model]](), file = dm_url)
      cat(MODULE, "Data model saved \n")

    }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Auto save the data:
    # --------------------------------------------------------------------------

    # -- Check parameter & observe items
    if(autosave)
      observeEvent(r[[r_items]](), {

        # -- Write
        kfiles::write_data(data = r[[r_items]](),
                           file = file,
                           path = path$data)

        # -- Notify
        cat(MODULE, "[EVENT] Item list has been (auto) saved \n")

      }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Declare triggers:
    # --------------------------------------------------------------------------

    # -- Build triggers names from module id
    trigger_add <- trigger_add_name(id)
    trigger_update <- trigger_update_name(id)
    trigger_delete <- trigger_delete_name(id)
    trigger_save <- trigger_save_name(id)

    # -- Declare reactive objects (for external use)
    r[[trigger_add]] <- reactiveVal(NULL)
    r[[trigger_update]] <- reactiveVal(NULL)
    r[[trigger_delete]] <- reactiveVal(NULL)
    r[[trigger_save]] <- reactiveVal(0)


    # -- Observe: trigger_add
    observeEvent(r[[trigger_add]](), {

      # -- add item to list & store
      cat(MODULE, "[TRIGGER] Add item \n")
      item_list <- item_add(r[[r_items]](), r[[trigger_add]]())
      r[[r_items]](item_list)

    }, ignoreInit = TRUE)


    # -- Observe: trigger_update
    observeEvent(r[[trigger_update]](), {

      # -- add item to list & store
      cat(MODULE, "[TRIGGER] Update item \n")
      item_list <- item_update(r[[r_items]](), r[[trigger_update]]())
      r[[r_items]](item_list)

    }, ignoreInit = TRUE)


    # -- Observe: trigger_delete
    observeEvent(r[[trigger_delete]](), {

      # -- add item to list & store
      cat(MODULE, "[TRIGGER] Delete item(s) \n")
      cat("-- Item(s) to be deleted =", as.character(r[[trigger_delete]]()), "\n")
      item_list <- item_delete(r[[r_items]](), r[[trigger_delete]]())
      r[[r_items]](item_list)

    }, ignoreInit = TRUE)


    # -- Observe: trigger_save (items)
    observeEvent(r[[trigger_save]](), {

      # -- Write
      kfiles::write_data(data = r[[r_items]](),
                         file = file,
                         path = path$data)

      # -- Notify
      cat(MODULE, "[TRIGGER] Item list has been saved \n")

    }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Declare filtered items:
    # --------------------------------------------------------------------------

    # -- Filtered item table view
    observeEvent({

      # -- Multiple conditions!
      r[[r_items]]()
      r[[r_filter_date]]()

    }, {

      cat(MODULE, "Updating filtered item view \n")

      # -- Get items
      items <- r[[r_items]]()

      # -- Apply date filter
      filter_date <- r[[r_filter_date]]()
      if(!is.null(filter_date))
        items <- items[items$date >= filter_date[1] & items$date <= filter_date[2], ]

      # -- Store
      r[[r_filtered_items]](items)

    }, ignoreInit = FALSE)


    # --------------------------------------------------------------------------
    # Declare admin outputs:
    # --------------------------------------------------------------------------

    # -- Raw view for admin
    output$raw_item_table <- DT::renderDT(r[[r_items]](),
                                          rownames = FALSE,
                                          options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
                                          selection = list(mode = 'single', target = "row", selected = NULL))

    # -- Masked view for admin (reuse of r_view_items)
    output$view_item_table <- DT::renderDT(view_apply_masks(r[[r_data_model]](), r[[r_items]]()),
                                           rownames = FALSE,
                                           selection = list(mode = 'single', target = "row", selected = NULL))

    # -- colClasses for admin
    output$data_model <- DT::renderDT(r[[r_data_model]](),
                                      rownames = TRUE,
                                      options = list(lengthMenu = c(5, 10, 15), pageLength = 10, dom = "t", scrollX = TRUE),
                                      selection = list(mode = 'single', target = "row", selected = NULL))


    # --------------------------------------------------------------------------
    # Declare outputs: Data tables
    # --------------------------------------------------------------------------

    # -- Default view (reuse of r_view_items, includes dm masks)
    output$default_view <- DT::renderDT(view_apply_masks(r[[r_data_model]](), r[[r_items]]()),
                                        rownames = FALSE,
                                        selection = list(mode = 'multiple', target = "row", selected = NULL))

    # -- Filtered view
    output$filtered_view <- DT::renderDT(view_apply_masks(r[[r_data_model]](), r[[r_filtered_items]]()),
                                        rownames = FALSE,
                                        selection = list(mode = 'multiple', target = "row", selected = NULL))


    # --------------------------------------------------------------------------
    # Managing in table selection
    # --------------------------------------------------------------------------

    # -- Default view
    observeEvent(input$default_view_rows_selected, {

      # -- Setting ignoreNULL to FALSE + check to allow unselect all (then r_selected_items will be NULL)
      if(is.null(input$default_view_rows_selected))
        ids <- NULL

      else {

        cat(MODULE, "Selected rows (default view) =", input$default_view_rows_selected, "\n")

        # -- Get item ids from the default view
        ids <- r[[r_items]]()[input$default_view_rows_selected, ]$id
        cat("-- ids =", as.character(ids), "\n")

      }

      # -- Store
      r[[r_selected_items]](ids)

    }, ignoreNULL = FALSE)


    # -- Filtered view
    observeEvent(input$filtered_view_rows_selected, {

      # -- Setting ignoreNULL to FALSE + check to allow unselect all (then r_selected_items will be NULL)
      if(is.null(input$filtered_view_rows_selected))
        ids <- NULL

      else {

        cat(MODULE, "Selected rows (filtered view) =", input$filtered_view_rows_selected, "\n")

        # -- Get item ids from the default view
        ids <- r[[r_filtered_items]]()[input$filtered_view_rows_selected, ]$id
        cat("-- ids =", as.character(ids), "\n")

      }

      # -- Store
      r[[r_selected_items]](ids)

    }, ignoreNULL = FALSE)


    # --------------------------------------------------------------------------
    # Declare outputs: Inputs
    # --------------------------------------------------------------------------

    # -- Declare date_slider (check date attribute)
    if(hasDate(isolate(r[[r_data_model]]()))){

      # -- Declare output
      output$date_slider <- input_date_slider(isolate(r[[r_items]]()), ns = ns)

      # -- Observe items min/max date
      observeEvent(r[[r_items]](), {

        # -- Get min/max
        if(dim(r[[r_items]]())[1] != 0){

          min <- min(r[[r_items]]()$date)
          max <- max(r[[r_items]]()$date)

        } else {

          min <- as.Date(Sys.Date())
          max <- min

        }

        # -- Update if needed
        if(min != ifelse(is.null(min_date()), 0, min_date()))
          min_date(min)

        if(max != ifelse(is.null(max_date()), 0, max_date()))
          max_date(max)

      }, ignoreInit = TRUE)

      # -- Observe for date range update
      observeEvent({
        min_date()
        max_date()
      }, {

        cat(MODULE, "Update sliderInput min/max \n")

        # -- update input
        updateSliderInput(session,
                          inputId = "date_slider",
                          min = min_date(),
                          max = max_date())

      })

    }

    # -- Observe: date_slider
    observeEvent(input$date_slider, {

      cat(MODULE, "Date sliderInput has been updated: \n")
      cat("-- values =", input$date_slider, "\n")

      r[[r_filter_date]](input$date_slider)

    })


    # --------------------------------------------------------------------------
    # Declare data model:
    # --------------------------------------------------------------------------

    output$hasDataModel <- reactive({

      if(is.null(r[[r_data_model]]()))
        FALSE
      else
        TRUE

    })

    outputOptions(output, "hasDataModel", suspendWhenHidden = FALSE)


    # --------------------------------------------------------------------------
    # Create data model:
    # --------------------------------------------------------------------------

    # -- Create from scratch
    output$admin_dm_create <- renderUI(

      # check for null data model
      if(is.null(r[[r_data_model]]()))
        actionButton(ns("dm_create"), label = "Create"))


    # --------------------------------------------------------------------------
    # Import data:
    # --------------------------------------------------------------------------

    # -- Import data
    output$admin_import_data <- renderUI(

      # check for null data model
      if(is.null(r[[r_data_model]]()))
        actionButton(ns("import_data"), label = "Import data"))


    # -- Observe: import_data
    observeEvent(input$import_data, {

      cat(MODULE, "[EVENT] Import data \n")

      # -- Display modal
      showModal(modalDialog(fileInput(inputId = ns("input_file"),
                                      label = "Select file",
                                      multiple = FALSE,
                                      accept = ".csv",
                                      buttonLabel = "Browse...",
                                      placeholder = "No file selected"),
                            title = "Import data",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("confirm_import_file"), "Next"))))

    })


    # -- Observe: confirm_import_file
    observeEvent(input$confirm_import_file, {

      # -- Check file input
      req(input$input_file)

      # -- Close modal
      removeModal()

      # -- Load the data
      file <- input$input_file
      items <- kfiles::read_data(file = file$datapath,
                                 path = NULL,
                                 colClasses = NA,
                                 create = FALSE)

      # -- Display modal
      showModal(modalDialog(DT::renderDT(items),
                            title = "Import data",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("confirm_import_data"), "Next"))))

      # -- Observe: confirm_import_data
      observeEvent(input$confirm_import_data, {

        # -- Close modal
        removeModal()

        # -- Get data model
        cat("Extract data model from data \n")
        data.model <- dm_check_integrity(data.model = NULL, items = items, template = TEMPLATE_DATA_MODEL)

        # -- Display modal
        showModal(modalDialog(p("Data model built from the data:"),
                              DT::renderDT(data.model),
                              title = "Import data",
                              footer = tagList(
                                modalButton("Cancel"),
                                actionButton(ns("confirm_data_model"), "Import"))))

        # -- Observe: confirm_data_model
        observeEvent(input$confirm_data_model, {

          # -- Close modal
          removeModal()

          # -- Store items & data model
          r[[r_items]](items)
          r[[r_data_model]](data.model)

        })

      })

    })


    # --------------------------------------------------------------------------
    # Declare danger zone:
    # --------------------------------------------------------------------------

    # -- Toggle btn
    output$dm_danger_btn <- renderUI(

      # -- Check for NULL data model
      if(!is.null(r[[r_data_model]]()))
        shinyWidgets::materialSwitch(inputId = ns("adm_dz_toggle"),
                                     label = "Danger zone",
                                     value = FALSE,
                                     status = "danger"))


    # -- Observe Toggle btn
    observeEvent(input$adm_dz_toggle,

                 # -- Define output
                 output$dm_danger_zone <- renderUI(

                   if(input$adm_dz_toggle)
                     shinydashboard::box(title = "Delete attribute", status = "danger", width = 4,

                                         tagList(

                                           # -- select attribute name
                                           selectizeInput(inputId = ns("dm_dz_att_name"),
                                                          label = "Name",
                                                          choices = colnames(r[[r_items]]()),
                                                          selected = NULL,
                                                          options = list(create = FALSE,
                                                                         placeholder = 'Type or select an option below',
                                                                         onInitialize = I('function() { this.setValue(""); }'))),

                                           # -- delete
                                           actionButton(ns("dm_dz_delete_att"), label = "Delete")))))


    # -- Observe button: delete attribute
    observeEvent(input$dm_dz_delete_att, {

      # -- check
      req(input$dm_dz_att_name)

      cat("[BTN] Delete attribute:", input$dm_dz_att_name, "\n")

      # -- drop column! & store
      items <- r[[r_items]]()
      items[input$dm_dz_att_name] <- NULL
      r[[r_items]](items)

      # -- update data model & store
      dm <- r[[r_data_model]]()
      dm <- dm[dm$name != input$dm_dz_att_name, ]
      r[[r_data_model]](dm)

    })


    # --------------------------------------------------------------------------
    # Add attribute to data model:
    # --------------------------------------------------------------------------

    # -- define inputs
    output$dm_add_att <- renderUI({

      # check
      if(is.null(r[[r_items]]()))
        NULL

      else {

        tagList(

          # attribute name
          selectizeInput(inputId = ns("add_att_name"),
                         label = "Name",
                         choices = TEMPLATE_DATA_MODEL$name[!TEMPLATE_DATA_MODEL$name %in% colnames(r[[r_items]]())],
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # attribute type
          selectizeInput(inputId = ns("add_att_type"),
                         label = "Type",
                         choices = OBJECT_CLASS,
                         selected = NULL,
                         options = list(create = FALSE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # attribute default.val
          selectizeInput(inputId = ns("add_att_default_val"),
                         label = "Default value",
                         choices = NULL,
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # attribute default.fun
          selectizeInput(inputId = ns("add_att_default_fun"),
                         label = "Default function",
                         choices = NULL,
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # skip
          checkboxInput(inputId = ns("add_att_skip"),
                        label = "Skip (input form)",
                        value = FALSE),

          # add attribute button
          actionButton(ns("add_att"), label = "Add attribute")

        ) # end tagList

      }})


    # -- update add_att_type given add_att_name
    observeEvent(input$add_att_name, {

      # -- check if input in template
      if(tolower(input$add_att_name) %in% TEMPLATE_DATA_MODEL$name)

        updateSelectizeInput(session = session,
                             inputId = "add_att_type",
                             choices = OBJECT_CLASS,
                             selected = TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == input$add_att_name, ]$type)})


    # -- update add_att_type given add_att_name
    observeEvent(input$add_att_type, {

      # -- check if input in template
      updateSelectizeInput(session = session,
                           inputId = "add_att_default_val",
                           choices = DEFAULT_VALUES[[input$add_att_type]],
                           selected = NULL)

      # -- check if input in template
      updateSelectizeInput(session = session,
                           inputId = "add_att_default_fun",
                           choices = DEFAULT_FUNCTIONS[[input$add_att_type]],
                           selected = NULL)

    })


    # -- BTN dm_create
    observeEvent(input$dm_create, {

      cat("[BTN] Create data \n")

      # -- init parameters (id)
      colClasses <- c("id" = "numeric")
      default_val <- c("id" = NA)
      default_fun <- c("id" = "ktools::getTimestamp")
      filter <- c("id")
      skip <- c("id")

      # -- init data model & store
      dm <- data_model(colClasses, default.val = default_val, default.fun = default_fun, filter = filter, skip = skip)
      r[[r_data_model]](dm)

      # -- init items
      items <- kfiles::read_data(file = file,
                                 path = path$data,
                                 colClasses = colClasses,
                                 create = TRUE)

      # -- store items
      r[[r_items]](items)

    })


    # -- BTN add_att
    observeEvent(input$add_att, {

      # check
      req(input$add_att_name,
          input$add_att_type)

      cat("[BTN] Add column \n")

      # Add attribute to the data model & store
      dm <- r[[r_data_model]]()
      dm <- dm_add_attribute(data.model = dm,
                             name = input$add_att_name,
                             type = input$add_att_type,
                             default.val = input$add_att_default_val,
                             default.fun = input$add_att_default_fun,
                             skip = input$add_att_skip,
                             filter = FALSE)
      r[[r_data_model]](dm)

      # -- get default value
      value <- dm_get_default(data.model = dm, name = input$add_att_name)

      # Add column to items & store
      items <- item_add_attribute(r[[r_items]](), name = input$add_att_name, type = input$add_att_type, fill = value)
      r[[r_items]](items)

    })


    # --------------------------------------------------------------------------
    # Sort attributes / columns:
    # --------------------------------------------------------------------------

    # -- define inputs
    output$dm_sort_buttons <- renderUI(

      # -- check NULL data model
      if(is.null(r[[r_items]]()))
        NULL

      else {

        tagList(

          # order attribute name
          selectizeInput(inputId = ns("dm_order_cols"),
                         label = "Select cols order",
                         choices = colnames(r[[r_items]]()),
                         selected = colnames(r[[r_items]]()),
                         multiple = TRUE),

          # order attribute button
          actionButton(ns("dm_sort_col"), label = "Reorder"))})


    # -- BTN sort_col
    observeEvent(input$dm_order_cols, {

      # -- Check
      req(length(input$dm_order_cols) == dim(r[[r_items]]())[2])

      cat("[BTN] Reorder column \n")

      # -- Reorder items & store
      r[[r_items]](r[[r_items]]()[input$dm_order_cols])

      # -- Reorder data model & store
      dm <- r[[r_data_model]]()
      dm <- dm[match(input$dm_order_cols, dm$name), ]
      r[[r_data_model]](dm)

    })


    # --------------------------------------------------------------------------
    # Filter view:
    # --------------------------------------------------------------------------

    # inputs
    output$adm_filter_buttons <- renderUI(

      # -- check NULL data model
      if(is.null(r[[r_items]]()))
        NULL

      else {

        # -- init params
        filter_cols <- dm_filter(r[[r_data_model]]())

        onInitialize <- if(is.null(filter_cols))
          I('function() { this.setValue(""); }')
        else
          NULL

        # -- define input
        selectizeInput(inputId = ns("adm_filter_col"),
                       label = "Filter columns",
                       choices = colnames(r[[r_items]]()),
                       selected = filter_cols,
                       multiple = TRUE,
                       options = list(create = FALSE,
                                      placeholder = 'Type or select an option below',
                                      onInitialize = onInitialize))})


    # observe filter input
    observeEvent(input$adm_filter_col, {

      cat("[BTN] Filter columns:", input$adm_filter_col, "\n")
      dm <- r[[r_data_model]]()

      # -- Check NULL data model
      if(!is.null(dm)){
        dm <- dm_filter_set(data.model = dm, filter = input$adm_filter_col)
        r[[r_data_model]](dm)}

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # --------------------------------------------------------------------------
    # Create item:
    # --------------------------------------------------------------------------

    # -- Declare: create_btn
    output$create_btn <- renderUI(actionButton(inputId = ns("create_btn"),
                                                 label = "Create"))

    # -- Observe: create_btn
    observeEvent(input$create_btn, {

      showModal(modalDialog(inputList(ns, item = NULL, update = FALSE, data.model = r[[r_data_model]]()),
                            title = "Create",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("confirm_create_btn"), "Create"))))

    })

    # -- Observe: confirm_create_btn
    observeEvent(input$confirm_create_btn, {

      cat(MODULE, "[EVENT] Create item \n")

      # -- close modal
      removeModal()

      # -- get list of input values & name it
      cat("--  Get list of input values \n")
      input_values <- get_input_values(input, dm_colClasses(r[[r_data_model]]()))

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = r[[r_data_model]]())

      # -- add item to list & store
      cat("--  Add item to list \n")
      item_list <- item_add(r[[r_items]](), item)
      r[[r_items]](item_list)

    })


    # --------------------------------------------------------------------------
    # Update item:
    # --------------------------------------------------------------------------

    # -- Declare: update_btn
    output$update_btn <- renderUI(

      # -- check item selection + single row
      if(is.null(r[[r_selected_items]]()) | length(r[[r_selected_items]]()) != 1)
        NULL
      else
        actionButton(inputId = ns("update_btn"),
                     label = "Update"))


    # -- Observe: update_btn
    observeEvent(input$update_btn, {

      cat(MODULE, "[EVENT] Update item \n")

      # -- Get selected item
      item <- r[[r_items]]()[r[[r_items]]()$id == r[[r_selected_items]](), ]

      # -- Dialog
      showModal(modalDialog(inputList(ns, item = item, update = TRUE, data.model = r[[r_data_model]]()),
                            title = "Update",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("confirm_update_btn"), "Update"))))

    })

    # -- Observe: confirm_update_btn
    observeEvent(input$confirm_update_btn, {

      cat(MODULE, "[EVENT] Confirm update item \n")

      # -- close modal
      removeModal()

      # -- get list of input values & name it
      cat("--  Get list of input values \n")
      input_values <- get_input_values(input, dm_colClasses(r[[r_data_model]]()))

      # -- update id (to replace selected item)
      input_values$id <- r[[r_selected_items]]()

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = r[[r_data_model]]())

      # -- update item & store
      cat("--  Call update trigger \n")
      r[[trigger_update]](item)

    })


    # --------------------------------------------------------------------------
    # Delete item(s):
    # --------------------------------------------------------------------------

    # -- Declare: delete_btn
    output$delete_btn <- renderUI(

      # -- check item selection
      if(is.null(r[[r_selected_items]]()))
        NULL
      else
        actionButton(inputId = ns("delete_btn"),
                     label = "Delete"))


    # -- Observe: create_btn
    observeEvent(input$delete_btn, {

      cat(MODULE, "[EVENT] Delete item(s) \n")

      # -- Open dialog for confirmation
      showModal(modalDialog(title = "Delete item(s)",
                            "Danger: deleting item(s) can't be undone! Do you confirm?",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("confirm_delete_btn"), "Delete"))))

    })

    # -- Observe: confirm_create_btn
    observeEvent(input$confirm_delete_btn, {

      cat(MODULE, "[EVENT] Confirm delete item(s) \n")

      # -- close modal
      removeModal()

      # -- get selected items (ids) & call trigger
      ids <- r[[r_selected_items]]()
      r[[trigger_delete]](ids)

    })


    # --------------------------------------------------------------------------
    # Sandbox:
    # --------------------------------------------------------------------------




  })
}

