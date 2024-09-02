

#' Module server
#'
#' @param id the id to be used for the module server instance
#' @param r the shared reactive value communication object
#' @param path a path where data model and items will be stored
#' @param create a logical whether the data file should be created or not if missing (default = TRUE)
#' @param autosave a logical whether the item auto save should be activated or not (default = TRUE)
#'
#' @import shiny shinydashboard shinyWidgets DT
#'
#' @export
#'
#' @details
#'
#' If autosave is FALSE, the save trigger should be used to make the data persistent
#'
#' @examples
#' \dontrun{
#' kitemsManager_Server(id = "mydata", r = r, path = "path/to/my/data",
#'                      create = TRUE, autosave = TRUE)
#' }


# ------------------------------------------------------------------------------
# Shiny module server logic
# ------------------------------------------------------------------------------

kitemsManager_Server <- function(id, r, path,
                                 create = TRUE, autosave = TRUE) {
  moduleServer(id, function(input, output, session) {

    # -- check reactive #240
    stopifnot(class(r) == "reactivevalues")

    # -- Check path (to avoid connection problems if missing folder)
    if(!dir.exists(path))
      dir.create(path)


    # --------------------------------------------------------------------------
    # Declare config parameters:
    # --------------------------------------------------------------------------

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    cat(MODULE, "Starting kitems module server... \n")

    # -- Check if app is running
    is_running <- shiny::isRunning()

    # -- Get namespace
    ns <- session$ns


    # --------------------------------------------------------------------------
    # Declare objects:
    # --------------------------------------------------------------------------

    # -- Init data
    data.model <- NULL
    items <- NULL

    # -- Build urls from module id
    dm_url <- file.path(path, paste0(dm_name(id), ".rds"))
    items_url <- file.path(path, paste0(items_name(id), ".csv"))

    # -- Build object names from module id (to access outside module)
    r_filtered_items <- filtered_items_name(id)
    r_selected_items <- selected_items_name(id)
    r_clicked_column <- clicked_column_name(id)
    r_filter_date <- filter_date_name(id)

    # -- Declare reactive objects (for external use)
    r[[r_filtered_items]] <- reactiveVal(NULL)
    r[[r_selected_items]] <- reactiveVal(NULL)
    r[[r_clicked_column]] <- reactiveVal(NULL)
    r[[r_filter_date]] <- reactiveVal(NULL)

    # -- Build triggers names from module id
    trigger_update <- trigger_update_name(id)
    trigger_delete <- trigger_delete_name(id)
    trigger_save <- trigger_save_name(id)
    trigger_create <- trigger_create_name(id)

    # -- Declare reactive objects (for external use)
    r[[trigger_update]] <- reactiveVal(NULL)
    r[[trigger_delete]] <- reactiveVal(NULL)
    r[[trigger_save]] <- reactiveVal(0)
    r[[trigger_create]] <- reactiveVal(0)
    cat(MODULE, "trigger_update available @", trigger_update, "\n")
    cat(MODULE, "trigger_delete available @", trigger_delete, "\n")
    cat(MODULE, "trigger_save available @", trigger_save, "\n")
    cat(MODULE, "trigger_create available @", trigger_create, "\n")


    # --------------------------------------------------------------------------
    # Initialize data model and items:
    # --------------------------------------------------------------------------

    # -- Notify progress
    withProgress(message = paste("Starting", MODULE, "item manager:"), value = 0, {

      # ------------------------------------------------------------------------
      # Read data model:
      # ------------------------------------------------------------------------

      cat(MODULE, "Checking if data model file exists:", dm_url, "\n")

      # -- Check url
      if(file.exists(dm_url)){

        cat(MODULE, "Reading data model from file \n")
        data.model <- readRDS(dm_url)
        cat(MODULE, "output dim =", dim(data.model),"\n")

      } else {

        cat(MODULE, "No data model file found. \n")

        }

      # Increment the progress bar, and update the detail text.
      incProgress(1/4, detail = "data model")


      # ------------------------------------------------------------------------
      # Read the data (items):
      # ------------------------------------------------------------------------

      # -- Check for NULL data model (then no reason to try loading)
      if(!is.null(data.model))

        items <- item_load(data.model = data.model,
                           file = items_url,
                           path = path,
                           create = create)

      # Increment the progress bar, and update the detail text.
      incProgress(2/4, detail = "items")


      # --------------------------------------------------------------------------
      # Check data model integrity:
      # --------------------------------------------------------------------------

      # -- Check for NULL data mode + data.frame
      if(!is.null(data.model) & !is.null(items)){

        cat(MODULE, "Checking data model integrity \n")
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
                             file = items_url,
                             path = path,
                             create = create)

        }}

      # Increment the progress bar, and update the detail text.
      incProgress(3/4, detail = "Integrity checked")


      # ------------------------------------------------------------------------
      # Store into reactive values:
      # ------------------------------------------------------------------------

      # -- Store data model (either content of the RDS or the server function input)
      k_data_model <- reactiveVal(data.model)

      # -- Store items
      k_items <- reactiveVal(items)

      # Increment the progress bar, and update the detail text.
      incProgress(4/4, detail = "done")

    }) #end withProgress


    # --------------------------------------------------------------------------
    # Auto save the data model:
    # --------------------------------------------------------------------------

    # -- Check parameter & observe data model
    if(autosave)
      observeEvent(k_data_model(), {

        # -- Write & notify
        saveRDS(k_data_model(), file = dm_url)
        cat(MODULE, "[EVENT] Data model has been (auto) saved \n")

      }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Auto save the data:
    # --------------------------------------------------------------------------

    # -- Check parameter & observe items
    if(autosave)
      observeEvent(k_items(), {

        # -- Write
        item_save(data = k_items(),
                  file = items_url,
                  path = path)

        # -- Notify
        cat(MODULE, "[EVENT] Item list has been (auto) saved \n")

      }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Triggers:
    # --------------------------------------------------------------------------

    # -- Observe: trigger_update
    observeEvent(r[[trigger_update]](), {

      # -- add item to list & store
      cat(MODULE, "[TRIGGER] Update item \n")
      item_list <- item_update(k_items(), r[[trigger_update]]())
      k_items(item_list)

      # -- notify
      if(is_running)
        showNotification(paste(MODULE, "Item updated."), type = "message")

    }, ignoreInit = TRUE)


    # -- Observe: trigger_delete
    observeEvent(r[[trigger_delete]](), {

      # -- add item to list & store
      cat(MODULE, "[TRIGGER] Delete item(s) \n")
      cat("-- Item(s) to be deleted =", as.character(r[[trigger_delete]]()), "\n")
      item_list <- item_delete(k_items(), r[[trigger_delete]]())
      k_items(item_list)

      # -- notify
      if(is_running)
        showNotification(paste(MODULE, "Item(s) deleted."), type = "message")

    }, ignoreInit = TRUE)


    # -- Observe: trigger_save (items)
    observeEvent(r[[trigger_save]](), {

      # -- Write
      item_save(data = k_items(),
                file = items_url,
                path = path)

      # -- Notify
      cat(MODULE, "[TRIGGER] Item list has been saved \n")
      if(is_running)
        showNotification(paste(MODULE, "Items saved."), type = "message")

    }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Declare filtered items:
    # --------------------------------------------------------------------------

    # -- Filtered item table view
    r[[r_filtered_items]] <- reactive({

      cat(MODULE, "Updating filtered item view \n")

      # -- Get items
      items <- k_items()

      # -- Apply date filter
      filter_date <- r[[r_filter_date]]()
      if(!is.null(filter_date))
        items <- items[items$date >= filter_date[1] & items$date <= filter_date[2], ]

      # -- Apply ordering
      if(!is.null(filter_date))
        items <- items[order(items$date, decreasing = TRUE), ]

      cat(MODULE, "ouput dim =", dim(items), "\n")

      # -- Return
      items

    })


    # # -- Filtered item table view
    # observeEvent({
    #
    #   # -- Multiple conditions!
    #   r[[r_items]]()
    #   r[[r_filter_date]]()
    #
    # }, {
    #
    #   cat(MODULE, "Updating filtered item view \n")
    #
    #   # -- Get items
    #   items <- r[[r_items]]()
    #
    #   # -- Apply date filter
    #   filter_date <- r[[r_filter_date]]()
    #   if(!is.null(filter_date))
    #     items <- items[items$date >= filter_date[1] & items$date <= filter_date[2], ]
    #
    #
    #   cat(MODULE, "ouput dim =", dim(items), "\n")
    #
    #   # -- Store
    #   r[[r_filtered_items]](items)
    #
    # }, ignoreInit = FALSE)


    # --------------------------------------------------------------------------
    # Declare admin outputs:
    # --------------------------------------------------------------------------

    # -- Raw view for admin
    output$raw_item_table <- DT::renderDT(k_items(),
                                          rownames = FALSE,
                                          options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
                                          selection = list(mode = 'single', target = "row", selected = NULL))

    # -- Masked view for admin (reuse of r_view_items)
    output$view_item_table <- DT::renderDT(view_apply_masks(k_data_model(), k_items()),
                                           rownames = FALSE,
                                           selection = list(mode = 'single', target = "row", selected = NULL))

    # -- colClasses for admin
    # setting rownames = FALSE #209
    # setting dom = "tpl" instead of "t" #245
    output$data_model <- DT::renderDT(dm_table_mask(k_data_model()),
                                      rownames = FALSE,
                                      options = list(lengthMenu = c(5, 10, 15), pageLength = 10, dom = "tpl", scrollX = TRUE),
                                      selection = list(mode = 'single', target = "row", selected = isolate(input$data_model_rows_selected)))


    # --------------------------------------------------------------------------
    # Declare outputs: Data tables
    # --------------------------------------------------------------------------

    # -- Default view (reuse of r_view_items, includes dm masks)
    output$default_view <- DT::renderDT(view_apply_masks(k_data_model(), k_items()),
                                        rownames = FALSE,
                                        selection = list(mode = 'multiple', target = "row", selected = NULL))

    # -- Filtered view
    output$filtered_view <- DT::renderDT(view_apply_masks(k_data_model(), r[[r_filtered_items]]()),
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
        ids <- k_items()[input$default_view_rows_selected, ]$id
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


    # -- Filtered view
    observeEvent(input$filtered_view_cell_clicked$col, {

      # -- Get table col names (need to apply masks to get correct columns, hence sending only first row)
      cols <- colnames(view_apply_masks(k_data_model(), head(r[[r_filtered_items]](), n = 1)))

      # -- Get name of the clicked column
      col_clicked <- cols[input$filtered_view_cell_clicked$col + 1]
      cat(MODULE, "Clicked column (filtered view) =", col_clicked, "\n")

      # -- Store
      r[[r_clicked_column]](col_clicked)

    }, ignoreNULL = TRUE)


    # --------------------------------------------------------------------------
    # Declare outputs: Inputs
    # --------------------------------------------------------------------------

    # -- date slider options
    output$date_slider_strategy <- renderUI(radioButtons(inputId = ns("date_slider_strategy"),
                                                         label = "Strategy",
                                                         choices = c("this-year", "keep-range"),
                                                         selected = "this-year",
                                                         inline = TRUE))


    # -- Declare output:
    output$date_slider <- renderUI({

      # -- check data model
      if(hasDate(k_data_model())){

        # -- Get min/max
        if(dim(k_items())[1] > 0){

          min <- min(k_items()$date)
          max <- max(k_items()$date)

        } else {

          min <- as.Date(Sys.Date())
          max <- min

        }

        # -- Get input range (to keep selection during update)
        range <- isolate(input$date_slider)

        # -- Set value
        # implement this_year strategy by default #211
        # keep this year after item is added #223 & #242
        value <- if(is.null(input$date_slider_strategy) || input$date_slider_strategy == "this-year")
          ktools::date_range(min, max, type = "this_year")
        else
          value <- range

        # -- date slider
        cat(MODULE, "Building date sliderInput \n")
        sliderInput(inputId = ns("date_slider"),
                    label = "Date",
                    min = min,
                    max = max,
                    value = value)

      } else NULL

    })


    # -- Observe: date_slider
    observeEvent(input$date_slider, {

      cat(MODULE, "Date sliderInput has been updated: \n")
      cat("-- values =", input$date_slider, "\n")

      # -- store
      r[[r_filter_date]](input$date_slider)

    })


    # --------------------------------------------------------------------------
    # Admin UI:
    # --------------------------------------------------------------------------
    # The whole section answers #206 (removes conditionalPanel on ui side and
    # computes on server side)

    # -- data model tab
    output$admin_dm_tab <- renderUI({

      # -- check NULL data model
      if(is.null(k_data_model())){

        # -- display create / import btns
        fluidRow(column(width = 12,
                        p("No data model found. You need to create one to start."),
                        actionButton(ns("dm_create"), label = "Create"),
                        actionButton(ns("import_data"), label = "Import data")))

      } else {

        # -- display data model
        tagList(

          fluidRow(column(width = 2,

                          p("Actions"),
                          uiOutput(ns("dm_att_form"))),

                   column(width = 10,
                          p("Table"),
                          DT::DTOutput(ns("data_model")),
                          br(),
                          p("Filter can be changed in the 'view' tab."))),

          fluidRow(column(width = 12,
                          br(),
                          uiOutput(ns("dm_danger_btn")),
                          uiOutput(ns("dm_danger_zone")))))

      }

    })


    # -- raw table tab
    output$admin_raw_tab <- renderUI({

      # -- check NULL data model
      if(!is.null(k_data_model())){

        # -- display raw table
        fluidRow(column(width = 2,
                        p("Actions"),
                        uiOutput(ns("dm_sort_buttons"))),

                 column(width = 10,
                        p("Raw Table"),
                        DT::DTOutput(ns("raw_item_table"))))

      }

    })


    # -- raw table tab
    output$admin_view_tab <- renderUI({

      # -- check NULL data model
      if(!is.null(k_data_model())){

        # -- display view table
        fluidRow(column(width = 2,
                        p("Actions"),
                        uiOutput(ns("adm_filter_buttons")),
                        p("Column name mask applied by default:",br(),
                          "- replace dot, underscore with space",br(),
                          "- capitalize first letters")),

                 column(width = 10,
                        p("Filtered Table"),
                        DT::DTOutput(ns("view_item_table"))))

      }

    })


    # --------------------------------------------------------------------------
    # Import data:
    # --------------------------------------------------------------------------

    # -- Observe: click (start import)
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


    # -- Observe: click (confirm file)
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

      # -- Check if datatset has id #208
      hasId <- if(!"id" %in% colnames(items)){

        # -- nb id to compute
        n <- nrow(items)

        # -- compute expected time (based on average time per id) #221
        expected_time <- round(n * 0.0156)

        # -- Display message has it can take a bit of time depending on dataset size
        showModal(modalDialog(p("Computing", n, "id(s) to import the dataset..."),
                              p("Expected time:", expected_time, "s"),
                              title = "Import data",
                              footer = NULL))

                # -- Compute a vector of ids (should be fixed by #214)
        cat(MODULE, "[WARNING] Dataset has no id column, creating one \n")
        fill <- ktools::seq_timestamp(n = n)

        # -- add attribute & reorder
        items <- kitems::item_add_attribute(items, name = "id", type = "numeric", fill = fill)
        items <- items[c("id", colnames(items)[!colnames(items) %in% "id"])]

        # -- close modal
        removeModal()

        # -- return
        FALSE

      } else TRUE

      # -- Display modal
      # adding options to renderDT #207
      showModal(modalDialog(DT::renderDT(items, rownames = FALSE, options = list(scrollX = TRUE)),
                            # -- test: in case no id column exists #208
                            if(!hasId)
                              p("Note: the dataset had no id column, it has been generated automatically."),
                            title = "Import data",
                            size = "l",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("confirm_import_data"), "Next"))))

      # -- Observe: click (confirm data)
      observeEvent(input$confirm_import_data, {

        # -- Close modal
        removeModal()

        # -- Get data model
        cat(MODULE, "Extract data model from data \n")
        data.model <- dm_check_integrity(data.model = NULL, items = items, template = TEMPLATE_DATA_MODEL)

        # -- Display modal
        # adding options to renderDT #207
        showModal(modalDialog(p("Data model built from the data:"),
                              DT::renderDT(data.model, rownames = FALSE, options = list(scrollX = TRUE)),
                              title = "Import data",
                              size = "l",
                              footer = tagList(
                                modalButton("Cancel"),
                                actionButton(ns("confirm_data_model"), "Import"))))

        # -- Observe: confirm_data_model
        observeEvent(input$confirm_data_model, {

          # -- Close modal
          removeModal()

          # -- Check items classes #216
          # Because dataset was read first, the current colclasses are 'guessed' and may not comply with the data model
          # ex: date class is forced in data model, but it may be char ("2024-02-07) or num (19760)
          items <- item_check_integrity(items = items, data.model = data.model)

          # -- Store items & data model
          k_items(items)
          data_model(data.model)

          # -- notify
          if(is_running)
            showNotification(paste(MODULE, "Data imported."), type = "message")

        })

      })

    })


    # --------------------------------------------------------------------------
    # Declare danger zone:
    # --------------------------------------------------------------------------

    # -- Toggle btn
    output$dm_danger_btn <- renderUI(

      # -- Check for NULL data model
      if(!is.null(k_data_model()))
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
                                                          choices = k_data_model()$name,
                                                          selected = NULL,
                                                          options = list(create = FALSE,
                                                                         placeholder = 'Type or select an option below',
                                                                         onInitialize = I('function() { this.setValue(""); }'))),

                                           # -- delete
                                           actionButton(ns("dm_dz_delete_att"), label = "Delete")))))


    # -- Observer button:
    observeEvent(input$dm_dz_delete_att, {

      # -- Open dialog for confirmation
      showModal(modalDialog(title = "Delete attribute",
                            "Danger: deleting an attribute can't be undone! Do you confirm?",
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("dm_dz_confirm_delete_att"), "Delete"))))})


    # -- Observe button: delete attribute
    observeEvent(input$dm_dz_confirm_delete_att, {

      # -- check
      req(input$dm_dz_att_name)

      cat("[BTN] Delete attribute:", input$dm_dz_att_name, "\n")

      # -- clode modal
      removeModal()

      # -- drop column! & store
      items <- k_items()
      items[input$dm_dz_att_name] <- NULL
      k_items(items)

      # -- update data model & store
      dm <- k_data_model()
      dm <- dm[dm$name != input$dm_dz_att_name, ]
      data_model(dm)

    })


    # --------------------------------------------------------------------------
    # Add attribute to data model:
    # --------------------------------------------------------------------------

    # -- update dm_att_type given dm_att_name
    observeEvent(input$dm_att_name, {

      # -- check if input in template
      if(tolower(input$dm_att_name) %in% TEMPLATE_DATA_MODEL$name)

        updateSelectizeInput(session = session,
                             inputId = "dm_att_type",
                             choices = OBJECT_CLASS,
                             selected = TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == input$dm_att_name, ]$type)})


    # -- update dm_att_default_detail given dm_att_type & dm_default_choice
    observeEvent({
      input$dm_att_type
      input$dm_default_choice}, {

        # -- set param
        if(input$dm_default_choice == "none")
          choices <- NULL
        else {
          choices <- if(input$dm_default_choice == "val")
            DEFAULT_VALUES[[input$dm_att_type]]
          else
            DEFAULT_FUNCTIONS[[input$dm_att_type]]}


        # -- check if input in template
        updateSelectizeInput(session = session,
                             inputId = "dm_att_default_detail",
                             choices = choices,
                             selected = NULL)

      })


    # -- BTN dm_create
    observeEvent(input$dm_create, {

      cat("[BTN] Create data \n")

      # -- init parameters (id)
      # Implement template #220
      template <- TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == "id", ]
      colClasses <- c("id" = template$type)
      filter <- if(template$filter) c("id") else NULL
      skip <- if(template$skip) c("id") else NULL

      # -- init data model & store
      cat(MODULE, "-- Building data model \n")
      dm <- data_model(colClasses = colClasses,
                       default.val = template$default.val,
                       default.fun = template$default.fun,
                       filter = filter,
                       skip = skip)

      # -- store
      data_model(dm)

      # -- init items
      cat(MODULE, "-- Init data \n")
      items <- kfiles::read_data(file = items_url,
                                 path = path,
                                 colClasses = colClasses,
                                 create = TRUE)

      # -- store items
      k_items(items)

    })


    # -- BTN add_att
    observeEvent(input$add_att, {

      # check
      req(input$dm_att_name,
          input$dm_att_type)

      cat("[BTN] Add column \n")

      # -- test default choice
      if(input$dm_default_choice == "none"){

        default_val <- NA
        default_fun <- NA

      } else {

        if(input$dm_default_choice == "val"){

          default_val <- input$dm_att_default_detail
          default_fun <- NA

        } else {

          default_val <- NA
          default_fun <- input$dm_att_default_detail}}


      # Add attribute to the data model & store
      dm <- k_data_model()
      dm <- dm_add_attribute(data.model = dm,
                             name = input$dm_att_name,
                             type = input$dm_att_type,
                             default.val = default_val,
                             default.fun = default_fun,
                             skip = input$dm_att_skip,
                             filter = FALSE)

      # -- store
      data_model(dm)

      # -- get default value
      value <- dm_get_default(data.model = dm, name = input$dm_att_name)

      # -- Add column to items & store
      items <- item_add_attribute(k_items(), name = input$dm_att_name, type = input$dm_att_type, fill = value)
      k_items(items)

      # -- update form
      # in case an attribute from template was added, it's necessary to drop it from available choices
      output$dm_att_form <- dm_inputs_ui(names = TEMPLATE_DATA_MODEL$name[!TEMPLATE_DATA_MODEL$name %in% colnames(k_items())],
                                         types = OBJECT_CLASS,
                                         ns = ns)

    })


    # -- observe data_model selected row
    observeEvent(input$data_model_rows_selected, {

      # -- get selected row
      row <- input$data_model_rows_selected

      # -- check NULL (no row selected)
      if(is.null(row)){

        # -- update form (creation mode, only if r_items not NULL)
        if(is.null(k_items()))
          output$dm_att_form <- NULL
        else
          output$dm_att_form <- dm_inputs_ui(names = TEMPLATE_DATA_MODEL$name[!TEMPLATE_DATA_MODEL$name %in% colnames(k_items())],
                                             types = OBJECT_CLASS,
                                             ns = ns)

      } else {

        # -- get attribute to update
        attribute <- k_data_model()[row, ]

        # -- update form (update mode)
        output$dm_att_form <- dm_inputs_ui(update = TRUE, attribute = attribute, ns = ns)

      }

    }, ignoreNULL = FALSE)


    # -- observe upd_att button
    observeEvent(input$upd_att, {

      # -- check
      #req(isTruthy(input$dm_att_default_detail))

      cat("[EVENT] Update data model attribute \n")

      # -- get selected row
      row <- input$data_model_rows_selected

      # -- get data model
      dm <- k_data_model()

      # -- default val & fun
      if(input$dm_default_choice == "none"){
        default_val <- NA
        default_fun <- NA

      } else {
        if(input$dm_default_choice == "val"){
          default_val <- input$dm_att_default_detail
          default_fun <- NULL

        } else {
          default_val <- NULL
          default_fun <- input$dm_att_default_detail}}

      # -- skip (force for id)
      skip <- if(dm[row, ]$name != "id")
        dm[row, ]$skip <- input$dm_att_skip
      else
        TRUE

      # -- update data model
      dm <- dm_update_attribute(dm,
                                name = dm[row, ]$name,
                                default.val = default_val,
                                default.fun = default_fun,
                                skip = skip)

      # -- store
      data_model(dm)

    })


    # --------------------------------------------------------------------------
    # Sort attributes / columns:
    # --------------------------------------------------------------------------

    # -- define inputs
    output$dm_sort_buttons <- renderUI(

      # -- check NULL data model
      if(is.null(k_data_model()))
        NULL

      else {

        tagList(

          # order attribute name
          selectizeInput(inputId = ns("dm_order_cols"),
                         label = "Select cols order",
                         choices = k_data_model()$name,
                         selected = k_data_model()$name,
                         multiple = TRUE))})


    # -- BTN sort_col
    observeEvent(input$dm_order_cols, {

      # -- Check
      req(length(input$dm_order_cols) == dim(k_items())[2])

      cat("[BTN] Reorder column \n")

      # -- Reorder items & store
      k_items(k_items()[input$dm_order_cols])

      # -- Reorder data model & store
      dm <- k_data_model()
      dm <- dm[match(input$dm_order_cols, dm$name), ]
      data_model(dm)

    })


    # --------------------------------------------------------------------------
    # Filter view:
    # --------------------------------------------------------------------------

    # inputs
    output$adm_filter_buttons <- renderUI(

      # -- check NULL data model
      if(is.null(k_data_model()))
        NULL

      else {

        # -- init params
        filter_cols <- dm_filter(k_data_model())

        onInitialize <- if(is.null(filter_cols))
          I('function() { this.setValue(""); }')
        else
          NULL

        # -- define input
        selectizeInput(inputId = ns("adm_filter_col"),
                       label = "Filter columns",
                       choices = k_data_model()$name,
                       selected = filter_cols,
                       multiple = TRUE,
                       options = list(create = FALSE,
                                      placeholder = 'Type or select an option below',
                                      onInitialize = onInitialize))})


    # observe filter input
    observeEvent(input$adm_filter_col, {

      cat("[BTN] Filter columns:", input$adm_filter_col, "\n")
      dm <- k_data_model()

      # -- Check NULL data model
      if(!is.null(dm)){
        dm <- dm_filter_set(data.model = dm, filter = input$adm_filter_col)
        data_model(dm)}

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # --------------------------------------------------------------------------
    # Create item:
    # --------------------------------------------------------------------------

    # -- Declare: create_btn
    output$create_btn_output <- renderUI(actionButton(inputId = ns("create_btn"),
                                                 label = "Create"))

    # -- Observe: create_btn & r[[trigger_create]]
    # Add trigger to fire observer without implementing the button in UI #252
    observeEvent({input$create_btn
      r[[trigger_create]]()}, {

        # -- check to avoid modal to fire at startup #256
        if(r[[trigger_create]]() != 0 | input$create_btn != 0)

          showModal(modalDialog(inputList(ns, item = NULL, update = FALSE, data.model = k_data_model()),
                                title = "Create",
                                footer = tagList(
                                  modalButton("Cancel"),
                                  actionButton(ns("confirm_create_btn"), "Create"))))

    }, ignoreInit = TRUE)

    # -- Observe: confirm_create_btn
    observeEvent(input$confirm_create_btn, {

      cat(MODULE, "[EVENT] Create item \n")

      # -- close modal
      removeModal()

      # -- get list of input values & name it
      cat("--  Get list of input values \n")
      input_values <- get_input_values(input, dm_colClasses(k_data_model()))

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = k_data_model())

      # -- update reactive
      item_add(k_items, item, name = id)

    })


    # --------------------------------------------------------------------------
    # Update item:
    # --------------------------------------------------------------------------

    # -- Declare: update_btn
    output$update_btn_output <- renderUI(

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
      item <- k_items()[k_items()$id == r[[r_selected_items]](), ]

      # -- Dialog
      showModal(modalDialog(inputList(ns, item = item, update = TRUE, data.model = k_data_model()),
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
      input_values <- get_input_values(input, dm_colClasses(k_data_model()))

      # -- update id (to replace selected item)
      input_values$id <- r[[r_selected_items]]()

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = k_data_model())

      # -- update item & store
      cat("--  Call update trigger \n")
      r[[trigger_update]](item)

    })


    # --------------------------------------------------------------------------
    # Delete item(s):
    # --------------------------------------------------------------------------

    # -- Declare: delete_btn
    output$delete_btn_output <- renderUI(

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

    # -- Observe: confirm_delete_btn
    observeEvent(input$confirm_delete_btn, {

      cat(MODULE, "[EVENT] Confirm delete item(s) \n")

      # -- close modal
      removeModal()

      # -- get selected items (ids) & call trigger
      ids <- r[[r_selected_items]]()
      r[[trigger_delete]](ids)

    })


    # --------------------------------------------------------------------------
    # Module server return value:
    # --------------------------------------------------------------------------

    # -- the reference (not the value!)
    list(id = id,
         items = k_items,
         data_model = k_data_model)

  })
}

