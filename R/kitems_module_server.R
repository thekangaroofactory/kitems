

#' Module server
#'
#' @param id the id to be used for the module server instance
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
#' If autosave is FALSE, the item_save function should be used to make the data persistent
#'
#' @examples
#' \dontrun{
#' kitemsManager_Server(id = "mydata", path = "path/to/my/data",
#'                      create = TRUE, autosave = TRUE)
#' }


# ------------------------------------------------------------------------------
# Shiny module server logic
# ------------------------------------------------------------------------------

kitemsManager_Server <- function(id, path,
                                 create = TRUE, autosave = TRUE) {

  moduleServer(id, function(input, output, session) {

    # -- Check path (to avoid connection problems if missing folder)
    if(!dir.exists(path))
      dir.create(path)


    # --------------------------------------------------------------------------
    # Declare config parameters:
    # --------------------------------------------------------------------------

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    cat(MODULE, "Starting kitems module server... \n")

    # -- Get namespace
    ns <- session$ns


    # --------------------------------------------------------------------------
    # Declare objects:
    # --------------------------------------------------------------------------

    # -- Init data (non persistent values to init the module)
    init_dm <- NULL
    init_items <- NULL

    # -- Build urls from module id
    dm_url <- file.path(path, paste0(dm_name(id), ".rds"))
    items_url <- file.path(path, paste0(items_name(id), ".csv"))

    # -- Declare reactive objects (for external use)
    filtered_items <- reactiveVal(NULL)
    selected_items <- reactiveVal(NULL)
    clicked_column <- reactiveVal(NULL)
    filter_date <- reactiveVal(NULL)

    # -- Declare internal reactives
    #w_update_attribute <- reactiveVal(NULL)
    isValid <- reactiveValues()
    isUpdate <- reactiveVal(FALSE)


    # --------------------------------------------------------------------------
    # Initialize data model and items:
    # --------------------------------------------------------------------------

    # -- Notify progress
    withProgress(message = MODULE, value = 0, {

      # ------------------------------------------------------------------------
      # Read data model:
      # ------------------------------------------------------------------------

      cat(MODULE, "Checking if data model file exists:\n")
      cat("-- path =", dirname(dm_url), "\n")
      cat("-- file =", basename(dm_url), "\n")

      # -- Check url
      if(file.exists(dm_url)){

        cat(MODULE, "Reading data model from file \n")
        init_dm <- readRDS(dm_url)
        cat("-- output dim =", dim(init_dm),"\n")

      } else {

        cat(">> No data model file found. \n")

        }

      # Increment the progress bar, and update the detail text.
      incProgress(1/4, detail = "Read data model")


      # ------------------------------------------------------------------------
      # Read the data (items):
      # ------------------------------------------------------------------------

      # -- Check for NULL data model (then no reason to try loading)
      if(!is.null(init_dm))

        init_items <- item_load(data.model = init_dm,
                           file = items_url,
                           path = path,
                           create = create)

      # Increment the progress bar, and update the detail text.
      incProgress(2/4, detail = "Read items")


      # ------------------------------------------------------------------------
      # Check data model integrity:
      # ------------------------------------------------------------------------

      # -- Check for NULL data model + data.frame
      if(!is.null(init_dm) & !is.null(init_items)){

        cat(MODULE, "Checking data model integrity \n")
        result <- dm_check_integrity(data.model = init_dm, items = init_items, template = TEMPLATE_DATA_MODEL)

        # -- Check feedback (otherwise value is TRUE)
        if(is.data.frame(result)){

          # -- Update data model & save
          init_dm <- result
          if(autosave){
            saveRDS(init_dm, file = dm_url)
            cat(MODULE, "Data model saved \n")}

          # -- Reload data with updated data model
          cat(MODULE, "Reloading the item data with updated data model \n")
          init_items <- item_load(data.model = init_dm,
                             file = items_url,
                             path = path,
                             create = create)

        } else cat("-- success, nothing to do \n")}


      # ------------------------------------------------------------------------
      # Check items integrity:
      # ------------------------------------------------------------------------

      # -- Check classes vs data.model
      if(!is.null(init_dm) & !is.null(init_items)){

        cat(MODULE, "Checking items classes integrity \n")
        init_items <- item_check_integrity(items = init_items,
                                           data.model = init_dm)}

      # Increment the progress bar, and update the detail text.
      incProgress(3/4, detail = "Integrity checked")


      # ------------------------------------------------------------------------
      # Store into reactive values:
      # ------------------------------------------------------------------------

      # -- Store data model (either content of the RDS or the server function input)
      k_data_model <- reactiveVal(init_dm)
      rm(init_dm)

      # -- Store items
      k_items <- reactiveVal(init_items)
      rm(init_items)

      # Increment the progress bar, and update the detail text.
      incProgress(4/4, detail = "Load data done")

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
        item_save(data = k_items(), file = items_url)

        # -- Notify
        cat(MODULE, "[EVENT] Item list has been (auto) saved \n")

      }, ignoreInit = TRUE)


    # --------------------------------------------------------------------------
    # Declare Inputs
    # --------------------------------------------------------------------------

    # -- date slider options
    output$date_slider_strategy <- renderUI(

      # -- check data model
      if(hasDate(k_data_model()))
        radioButtons(inputId = ns("date_slider_strategy"),
                     label = "Strategy",
                     choices = c("this-year", "keep-range"),
                     selected = "this-year",
                     inline = TRUE)
      else NULL)


    # -- date slider
    output$date_slider <- renderUI({

      # -- check data model
      if(hasDate(k_data_model()) & !is.null(input$date_slider_strategy)){

        cat(MODULE, "Building date sliderInput \n")
        cat("- strategy =", input$date_slider_strategy, "\n")

        # -- Get min/max
        if(dim(k_items())[1] > 0){

          min <- min(k_items()$date)
          max <- max(k_items()$date)

        } else {

          min <- as.Date(Sys.Date())
          max <- min

        }

        # -- Get input range (to keep selection during update)
        #range <- isolate(input$date_slider)

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


    # --------------------------------------------------------------------------
    # Observe Inputs
    # --------------------------------------------------------------------------

    # -- Observe: date_slider
    observeEvent(input$date_slider, {

      cat(MODULE, "Date sliderInput has been updated: \n")
      cat("-- values =", input$date_slider, "\n")

      # -- store
      filter_date(input$date_slider)

    })


    # --------------------------------------------------------------------------
    # Declare filtered items:
    # --------------------------------------------------------------------------

    # -- Filtered item table view
    filtered_items <- reactive(

      # -- check
      if(!is.null(filter_date())){

        cat(MODULE, "Updating filtered item view \n")

        # -- init
        items <- k_items()
        dm <- k_data_model()

        # -- Apply date filter
        items <- items[items$date >= filter_date()[1] & items$date <= filter_date()[2], ]

        # -- Apply ordering
        if(any(!is.na(dm$sort.rank)))
          items <- item_sort(items, dm)

        cat("-- ouput dim =", dim(items), "\n")

        # -- Return
        items

      } else k_items()

    )


    # --------------------------------------------------------------------------
    # Declare admin outputs:
    # --------------------------------------------------------------------------

    # -- Raw view for admin
    output$raw_item_table <- DT::renderDT(k_items(),
                                          rownames = FALSE,
                                          options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
                                          selection = list(mode = 'single', target = "row", selected = NULL))

    # -- Masked view for admin
    output$view_item_table <- DT::renderDT(view_apply_masks(k_data_model(), k_items()),
                                           rownames = FALSE,
                                           selection = list(mode = 'single', target = "row", selected = NULL))

    # -- colClasses for admin
    # setting rownames = FALSE #209
    # setting dom = "tpl" instead of "t" #245
    # allowing display all #244
    output$data_model <- DT::renderDT(dm_table_mask(k_data_model()),
                                      rownames = FALSE,
                                      options = list(lengthMenu = list(c(20, 50, -1), c('20', '50', 'All')),
                                                     pageLength = 20, dom = "tpl", scrollX = TRUE),
                                      selection = list(mode = 'single', target = "row", selected = isolate(input$data_model_rows_selected)))


    # --------------------------------------------------------------------------
    # Declare outputs: Data tables
    # --------------------------------------------------------------------------

    # -- Filtered view
    output$filtered_view <- DT::renderDT(view_apply_masks(k_data_model(), filtered_items()),
                                        rownames = FALSE,
                                        selection = list(mode = 'multiple', target = "row", selected = NULL))


    # --------------------------------------------------------------------------
    # Managing in table selection
    # --------------------------------------------------------------------------

    # -- Filtered view
    observeEvent(input$filtered_view_rows_selected, {

      # -- Setting ignoreNULL to FALSE + check to allow unselect all (then selected_items will be NULL)
      if(is.null(input$filtered_view_rows_selected))
        ids <- NULL

      else {

        cat(MODULE, "Selected rows (filtered view) =", input$filtered_view_rows_selected, "\n")

        # -- Get item ids from the default view
        ids <- filtered_items()[input$filtered_view_rows_selected, ]$id
        cat("-- ids =", as.character(ids), "\n")

      }

      # -- Store
      selected_items(ids)

    }, ignoreNULL = FALSE)


    # -- Filtered view
    observeEvent(input$filtered_view_cell_clicked$col, {

      # -- Get table col names (need to apply masks to get correct columns, hence sending only first row)
      cols <- colnames(view_apply_masks(k_data_model(), utils::head(filtered_items(), n = 1)))

      # -- Get name of the clicked column
      col_clicked <- cols[input$filtered_view_cell_clicked$col + 1]
      cat(MODULE, "Clicked column (filtered view) =", col_clicked, "\n")

      # -- Store
      clicked_column(col_clicked)

    }, ignoreNULL = TRUE)


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

                        # -- Check if item file already exists:
                        # if data model was deleted, but not the items #282
                        if(file.exists(items_url))
                          p("Item file already exists: you need to delete it before creating a new data model.", br(),
                            items_url)
                        else
                          actionButton(ns("dm_create"), label = "Create"),

                        actionButton(ns("import_data"), label = "Import data")))

      } else {

        # -- display data model
        tagList(

          if(!autosave)
            fluidRow(column(width = 12),
                     shinydashboard::box("Modification in the data model won't be saved.", title = "Autosave off", status = "warning",
                                         solidHeader = TRUE, collapsible = TRUE)),

          # -- the table
          fluidRow(column(width = 12,
                          h3("Table"),
                          DT::DTOutput(ns("data_model")))),

          # -- actions
          fluidRow(column(width = 12,
                          h3("Actions"),
                          actionButton(inputId = ns("w_new_attribute"), label = "New attribute"),
                          uiOutput(ns("update_attribute")))),

          # -- info
          fluidRow(column(width = 12,
                          p(icon(name = "circle-info"), "Filter can also be changed in the 'view' tab."))),

          # -- danger zone
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
        items <- item_add_attribute(items, name = "id", type = "numeric", fill = fill)
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
        init_dm <- dm_check_integrity(data.model = NULL, items = items, template = TEMPLATE_DATA_MODEL)

        # -- Display modal
        # adding options to renderDT #207
        showModal(modalDialog(p("Data model built from the data:"),
                              DT::renderDT(init_dm, rownames = FALSE, options = list(scrollX = TRUE)),
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
          items <- item_check_integrity(items = items, data.model = init_dm)

          # -- Store items & data model
          k_items(items)
          k_data_model(init_dm)

          # -- notify
          if(shiny::isRunning())
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

                   # -- check toggle btn
                   if(input$adm_dz_toggle){

                     tagList(

                       # -- delete attribute
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

                                             # -- delete att
                                             actionButton(ns("dm_dz_delete_att"), label = "Delete"))),

                       # -- delete data model
                       shinydashboard::box(title = "Delete data model", status = "danger", width = 4,
                                           p("Click here to delete the data model and ALL corresponding items."),
                                           actionButton(ns("dm_dz_delete_dm"), label = "Delete all!")))}))


    # --------------------------------------------------------------------------
    # Delete attribute:
    # --------------------------------------------------------------------------

    # -- Observer button:
    observeEvent(input$dm_dz_delete_att, {

      # -- check data model size (to display warning)
      single_row <- nrow(k_data_model()) == 1

      # -- Open dialog for confirmation
      showModal(modalDialog(title = "Delete attribute",
                            p("Danger: deleting an attribute can't be undone! Do you confirm?"),
                            if(single_row) p("Note that the data model will be deleted since this is the last attribute."),
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

      # -- drop column!
      cat(MODULE, "Drop attribute from all items \n")
      items <- k_items()
      items[input$dm_dz_att_name] <- NULL

      # -- update data model
      cat(MODULE, "Drop attribute from data model \n")
      dm <- k_data_model()
      dm <- dm[dm$name != input$dm_dz_att_name, ]


      # -- check for empty data model & store
      if(nrow(dm) == 0){
        cat(MODULE, "Warning! Empty Data model, cleaning data model & items \n")
        k_items(NULL)
        k_data_model(NULL)

        if(autosave){
          cat(MODULE, "Deleting data model & item files \n")
          unlink(dm_url)
          unlink(items_url)

          # -- notify
          if(shiny::isRunning())
            showNotification(paste(MODULE, "Empty data model deleted."), type = "message")}

      } else {
        k_items(items)
        k_data_model(dm)

        # -- notify
        if(shiny::isRunning())
          showNotification(paste(MODULE, "Attribute deleted."), type = "message")}

    })

    # --------------------------------------------------------------------------
    # Delete data model:
    # --------------------------------------------------------------------------

    # -- Observer button:
    observeEvent(input$dm_dz_delete_dm, {

      cat(MODULE, "Delete data model preview \n")

      # -- Open dialog for confirmation
      showModal(modalDialog(title = "Delete data model",

                            p("Danger: deleting a data model can't be undone! Do you confirm?", br(),

                              # -- check items
                              if(!is.null(k_items()))
                                "- All items in session will be deleted", br(),

                              # -- check dm file
                              if(file.exists(dm_url)){
                                if(autosave)
                                  "- Data model file will be deleted"
                                else
                                  "- Data model file won't be deleted (autosave is off)"}),

                            # -- check items file
                            if(file.exists(items_url) & autosave)
                              checkboxInput(inputId = ns("dm_dz_confirm_delete_dm_items"), label = "Delete items file"),

                            # -- confirm string
                            p("Type the following string:", paste0("delete_", id)),
                            textInput(inputId = ns("dm_dz_confirm_delete_dm_string"),
                                      label = ""),

                            # -- footer
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("dm_dz_confirm_delete_dm"), "Delete"))))})


    # -- Observer button:
    observeEvent(input$dm_dz_confirm_delete_dm, {

      # -- check string
      req(input$dm_dz_confirm_delete_dm_string == paste0("delete_", id))

      cat(MODULE, "Delete data model confirmed! \n")

      # -- close dialog
      removeModal()

      # -- delete items
      if(!is.null(k_items()))
        k_items(NULL)

      # -- delete data model & file
      k_data_model(NULL)
      if(file.exists(dm_url) & autosave)
        unlink(dm_url)

      # -- delete items file
      if(file.exists(items_url) & autosave)
        if(input$dm_dz_confirm_delete_dm_items)
          unlink(items_url)

      # -- notify
      if(shiny::isRunning())
        showNotification(paste(MODULE, "Data model deleted."), type = "warning")

    })


    # --------------------------------------------------------------------------
    # Create data model:
    # --------------------------------------------------------------------------

    # -- Observe: actionButton
    observeEvent(input$dm_create, {

      cat("[BTN] Create data \n")

      # -- init parameters (id)
      # Implement template #220
      template <- TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == "id", ]
      colClasses <- stats::setNames(template$type, template$name)
      default_val <- stats::setNames(template$default.val, template$name)
      default_fun <- stats::setNames(template$default.fun, template$name)
      filter <- if(template$filter) template$name else NULL
      skip <- if(template$skip) template$name else NULL

      # -- init data model & store
      cat(MODULE, "-- Building data model \n")
      dm <- data_model(colClasses = colClasses,
                       default.val = default_val,
                       default.fun = default_fun,
                       filter = filter,
                       skip = skip)

      # -- store
      k_data_model(dm)

      # -- init items
      # create = autosave : so that file won't be created if autosave is FALSE #271
      cat(MODULE, "-- Init data \n")
      items <- kfiles::read_data(file = items_url,
                                 path = path,
                                 colClasses = colClasses,
                                 create = autosave)

      # -- store items
      k_items(items)

    })


    # --------------------------------------------------------------------------
    # Data model attribute wizard ----
    # --------------------------------------------------------------------------

    # ---------------------------------
    # Step.1: attribute name & type ----
    # ---------------------------------
    # Note: there is no need to support update in step.1

    # -- observe button
    # Added #281
    observeEvent(input$w_new_attribute, {

      cat("[EVENT] Create data model attribute wizard \n")

      # -- init
      isUpdate(FALSE)
      isValid$name <- FALSE
      isValid$type <- FALSE

      # -- prepare
      names <- TEMPLATE_DATA_MODEL[!TEMPLATE_DATA_MODEL$name %in% k_data_model()$name, "name"]
      types <- OBJECT_CLASS

      # -- display modal
      showModal(modalDialog(

        # -- body
        tagList(

          h4("Step 1:"),
          p("Define attribute name and type."),

          # -- attribute name
          selectizeInput(inputId = ns("w_name"),
                         label = "Name",
                         choices = names,
                         selected = NULL,
                         options = list(create = TRUE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # -- attribute type
          selectizeInput(inputId = ns("w_type"),
                         label = "Type",
                         choices = types,
                         selected = NULL,
                         options = list(create = FALSE,
                                        placeholder = 'Type or select an option below',
                                        onInitialize = I('function() { this.setValue(""); }'))),

          # -- comments
          uiOutput(ns("w_name_note")),
          uiOutput(ns("w_type_note"))

        ),

        # -- params
        title = "Attribute setup assistant",
        footer = tagList(
          modalButton("Cancel"),
          actionButton(inputId = ns("w_confirm_1"), label = "Next",
                       onclick = sprintf('Shiny.setInputValue(\"%s\", "create", {priority: \"event\"})',
                                         ns("w_set_default"))))))

    })


    # -- check attribute name
    observeEvent(input$w_name, {

      # -- empty
      if(input$w_name == ""){

        name <- "xmark"
        style <- "color: #FFD43B;"
        msg <- "Attribute name is empty"
        isValid$name <- FALSE

      } else {

        # -- duplicate name
        if(input$w_name %in% k_data_model()$name){

          name <- "circle-xmark"
          style <- "color: #ff0000;"
          msg <- "This attribute name is already used in the data model!"
          isValid$name <- FALSE

        } else {

          # -- good
          name <- "check"
          style <- "color: #80ff80;"
          msg <- "Attribute name is ok"
          isValid$name <- TRUE

          # -- update default type
          if(input$w_name %in% TEMPLATE_DATA_MODEL$name)
            updateSelectizeInput(inputId = "w_type",
                                 selected = TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == input$w_name, ]$type)

        }}

      # -- note
      output$w_name_note <- renderUI(tagList(icon(name = name, class = "fa-solid", style = style), msg))

    })


    # -- check attribute type
    observeEvent(input$w_type, {

      # -- empty
      if(input$w_type == ""){

        name <- "xmark"
        style <- "color: #FFD43B;"
        msg <- "Attribute type is empty"
        isValid$type <- FALSE

      } else {

        # -- good
        name <- "check"
        style <- "color: #80ff80;"
        msg <- paste("Sample value:", as.character(CLASS_EXAMPLES[[input$w_type]]))
        isValid$type <- TRUE

      }

      # -- note
      output$w_type_note <- renderUI(tagList(icon(name = name, class = "fa-solid", style = style), msg))

    })


    # ---------------------------------
    # Step.2: defaults ----
    # ---------------------------------
    # entry point for the update process (step.1 skipped)

    # -- observe button
    observeEvent(input$w_set_default, {

      # -- check input (entry point for update)
      if(input$w_set_default == "update"){

        cat("[EVENT] Update data model attribute wizard \n")

        # -- init values (to pass req)
        isValid$name <- TRUE
        isValid$type <- TRUE
        isUpdate(TRUE)}

      # -- Requires valid name & type
      req(isValid$name & isValid$type)
      removeModal()

      # -- init input params
      if(isUpdate()){

        # -- get attribute
        attribute <- k_data_model()[input$data_model_rows_selected, ]

        name <- attribute$name
        type <- attribute$type
        selected <- if(!is.na(attribute$default.fun)) "fun" else
          if(!is.na(attribute$default.val)) "val" else "none"

        # -- case when w_default_choice input has already same value as selected
        # need to update other inputs otherwise they keep old values
        if(!is.null(input$w_default_choice))
          if(selected == "val" & input$w_default_choice == "val"){

            updateTextInput(inputId = "w_default_val",
                            value = attribute$default.val)

          } else if(selected == "fun" & input$w_default_choice == "fun"){

            updateSelectizeInput(inputId = "w_default_fun",
                                 choices = unique(c(attribute$default.fun, DEFAULT_FUNCTIONS[[attribute$type]])),
                                 selected = attribute$default.fun)

            updateTextInput(inputId = "w_default_arg",
                            value = attribute$default.arg)}

      } else { # -- create

        name <- input$w_name
        type <- input$w_type
        selected <- "none"}

      cat("[step.2] init: name =", name, "/ type =", type, "/ selected =", selected, "\n")

      # -- display modal
      showModal(modalDialog(

        # -- body
        tagList(

          h4("Step 2:"),
          p("Setup how default values should be generated."),

          p("Attribute:"),
          tags$ul(
            tags$li("name =", name),
            tags$li("type =", type)),

          # -- default strategy
          radioButtons(inputId = ns("w_default_choice"),
                       label = "Choose strategy:",
                       choices = c("no default" = "none", "value" = "val", "function" = "fun"),
                       selected = selected),

          # -- default details
          uiOutput(ns("w_default_detail")),

          # -- comments
          uiOutput(ns("w_default_note"))),

        # -- params
        title = "Attribute setup assistant",
        footer = tagList(
          modalButton("Cancel"),
          actionButton(inputId = ns("w_set_sf"), "Next"))))

    })


    # -- Observe radioButtons
    observeEvent(input$w_default_choice, {

      cat("[step.2] w_default_choice input =", input$w_default_choice, "\n")

      # -- no default
      if(input$w_default_choice == "none"){

        # -- no need for detail input
        output$w_default_detail <- NULL
        output$w_default_note <- renderUI(tagList(icon(name = "check",
                                                       class = "fa-solid",
                                                       style = "color: #80ff80;"),
                                                  "Default value will be NA"))

        # -- so next is available
        isValid$default_detail <- TRUE

      } else {

        # -- default value
        if(input$w_default_choice == "val"){

          # -- setup input params
          if(isUpdate()){

            attribute <- k_data_model()[input$data_model_rows_selected, ]
            value <- attribute$default.val

          } else { # -- create

            value <- DEFAULT_VALUES[[input$w_type]]}

          cat("[step.2] Set w_default_val: value =", value, "\n")

          # -- update outputs
          output$w_default_detail <- renderUI(tagList(
            p("Rule: any value that can be coerced to the expected type"),
            textInput(inputId = ns("w_default_val"),
                      label = "Default value",
                      value = value,
                      placeholder = "Enter a valid value")))

        } else { # -- default function

          # -- setup input params
          if(isUpdate()){

            attribute <- k_data_model()[input$data_model_rows_selected, ]
            choices <- unique(c(attribute$default.fun, DEFAULT_FUNCTIONS[[attribute$type]]))
            selected <- attribute$default.fun
            value <- attribute$default.arg

          } else { # -- create

            choices <- DEFAULT_FUNCTIONS[[input$w_type]]
            selected <- NULL
            value <- NULL}

          cat("[step.2] Set w_default_fun: selected =", selected, "\n")

          # -- update outputs
          output$w_default_detail <- renderUI(tagList(

            p("The function must be reachable with a do.call:"),
            tags$ul(
              tags$li("either loaded in the global environment"),
              tags$li("or accessible in an installed package (ex: pkg::function)")),

            # -- function
            selectizeInput(inputId = ns("w_default_fun"),
                           label = "Default function",
                           choices = choices,
                           selected = selected,
                           options = list(create = TRUE,
                                          placeholder = "Enter a valid functions name without ()")),

            p("It can take arguments provided as a list (see ?do.call)"),

            # -- arguments
            textInput(inputId = ns("w_default_arg"),
                      label = "Arguments",
                      value = value,
                      placeholder = "Enter arguments, ex: list(a = 1, b = TRUE)")))}}

    })


    # -- observe textInput (value)
    # takes w_default_choice to update messages upon radio change
    observeEvent({
      input$w_default_choice
      input$w_default_val}, {

        # -- check
        if(input$w_default_choice == "val"){

          cat("[step.2] w_default_val =", input$w_default_val, "\n")

          # -- empty
          if(input$w_default_val == ""){

            name <- "xmark"
            style <- "color: #FFD43B;"
            msg <- "Default value is empty"
            isValid$default_detail <- FALSE

          } else {

            # -- check update
            type <- if(isUpdate())
              k_data_model()[input$data_model_rows_selected, ]$type
            else
              input$w_type

            # -- try: coerce input to expected class
            cat("[step.2] Eval default value \n")
            value <- tryCatch(
              eval(call(CLASS_FUNCTIONS[[type]], input$w_default_val)),
              error = function(e) e,
              warning = function(w) w)

            # -- check output
            if("error" %in% class(value)){

              cat("[Error]", value$message)
              name <- "circle-xmark"
              style <- "color: #ff0000;"
              msg <- paste("Default value is KO, error =", value$message)
              isValid$default_detail <- FALSE

            } else {

              if("warning" %in% class(value)){

                cat("[Warning]", value$message)
                name <- "xmark"
                style <- "color: #FFD43B;"
                msg <- paste("Default value is KO, warning =", value$message)
                isValid$default_detail <- FALSE

              } else {

                name <- "check"
                style <- "color: #80ff80;"
                msg <- paste0("Default value is OK [class = ", class(value)[1], " / value = ", value, "]")
                isValid$default_detail <- TRUE}}}

          # -- update output
          output$w_default_note <- renderUI(tagList(icon(name = name,
                                                         class = "fa-solid",
                                                         style = style), msg))}

    })


    # -- observe textInput (function & arg)
    # takes w_default_choice to update messages upon radio change
    observeEvent({
      input$w_default_choice
      input$w_default_fun
      input$w_default_arg}, {

        # -- check
        if(input$w_default_choice == "fun"){

          cat("[step.2] w_default_fun =", input$w_default_fun, "\n")
          cat("[step.2] w_default_arg =", input$w_default_arg, "\n")

          # -- empty
          if(input$w_default_fun == ""){

            name <- "xmark"
            style <- "color: #FFD43B;"
            msg <- paste("Default function is empty")
            isValid$default_detail <- FALSE

          } else {

            # -- check args
            if(input$w_default_arg == "")
              args <- list()

            else {

              # -- eval input
              cat("[step.2] Eval function arguments \n")
              args <- tryCatch(eval(parse(text = input$w_default_arg)),
                               error = function(e) e,
                               warning = function(w) w)

              # -- check output
              if("error" %in% class(args))
                print(args$message)

              else if("warning" %in% class(args))
                print(args$message)

            }

            # -- check update
            type <- if(isUpdate())
              k_data_model()[input$data_model_rows_selected, ]$type
            else
              input$w_type


            # -- try: call given function
            cat("[step.2] Eval function \n")
            value <-  tryCatch(
              eval(call(CLASS_FUNCTIONS[[type]], eval(do.call(ktools::getNsFunction(input$w_default_fun), args = args)))),
              error = function(e) e,
              warning = function(w) w)

            # -- check output
            if("error" %in% class(value)){

              cat("[Error]", value$message)
              name <- "circle-xmark"
              style <- "color: #ff0000;"
              msg <- paste("Default funcion is KO, error =", value$message)
              isValid$default_detail <- FALSE

            } else {

              if("warning" %in% class(value)){

                cat("[Warning]", value$message)
                name <- "xmark"
                style <- "color: #FFD43B;"
                msg <- paste("Default function is KO, warning =", value$message)
                isValid$default_detail <- FALSE

              } else { # -- no error or warning

                # -- check class
                name <- "check"
                style <- "color: #80ff80;"
                msg <- paste0("Default function is OK [class = ", class(value)[1], " / value = ", value, "]")
                isValid$default_detail <- TRUE}}}

          # -- update output
          output$w_default_note <- renderUI(tagList(icon(name = name,
                                                         class = "fa-solid",
                                                         style = style), msg))}

      })


    # ---------------------------------
    # Step.3: skip & filter
    # ---------------------------------

    # -- observer actionButton
    observeEvent(input$w_set_sf, {

      # -- Requires valid defaults
      req(isValid$default_detail)
      removeModal()

      # -- init input values
      if(isUpdate()){

        attribute <- k_data_model()[input$data_model_rows_selected, ]
        value_skip <- attribute$skip
        value_filter <- attribute$filter

      } else {

        value_skip <- FALSE
        value_filter <- FALSE}

      cat("[step.3] init: skip =", value_skip, "/ filter =", value_filter, "\n")


      # -- display modal
      showModal(modalDialog(

        # -- body
        tagList(

          h4("Step 3:"),
          p("Setup skip & filter."),

          # -- skip
          p("Should the attribute be skipped from the item creation form", br(), "(default strategy will be applied to fill the value)"),
          checkboxInput(inputId = ns("w_skip"),
                        label = "Skip",
                        value = value_skip),

          # -- filter
          p("Should the attribute be filtered from the item view"),
          checkboxInput(inputId = ns("w_filter"),
                        label = "Filter",
                        value = value_filter)),

        # -- params
        title = "Attribute setup assistant",
        footer = tagList(
          modalButton("Cancel"),
          actionButton(inputId = ns("w_set_sort"), "Next"))))

    })


    # ---------------------------------
    # Step.4: order
    # ---------------------------------

    # -- observer actionButton
    observeEvent(input$w_set_sort, {

      # -- Close window
      removeModal()

      # -- init input params
      if(isUpdate()){

        # -- get attribute
        attribute <- k_data_model()[input$data_model_rows_selected, ]
        value <- ifelse(is.na(attribute$sort.rank), FALSE, TRUE)

        # -- make sure options are correctly set
        if(value){
          updateNumericInput(inputId = "w_sort_rank",
                             value = attribute$sort.rank)

          updateRadioButtons(inputId = "w_sort_desc",
                             selected = attribute$sort.desc)}

      } else
        value <- FALSE

      cat("[step.4] init: ordering =", value, "\n")

      # -- display modal
      showModal(modalDialog(

        # -- body
        tagList(

          h4("Step 4:"),
          p("Setup ordering options."),

          # -- set ordering
          p("Should the attribute be filtered from the item view"),
          checkboxInput(inputId = ns("w_sort"),
                        label = "Ordering",
                        value = value),

          # -- details
          uiOutput(ns("w_sort_details"))

          ),

        # -- params
        title = "Attribute setup assistant",
        footer = tagList(
          modalButton("Cancel"),
          actionButton(inputId = ns("w_ask_confirm"), "Next"))))

    })


    # -- observe checkbox
    observeEvent(input$w_sort, {

      if(input$w_sort){

        # -- prepare
        value_rank <- 1
        value_desc <- FALSE

        # -- update outputs
        output$w_sort_details <- renderUI(tagList(

          # -- rank
          p("In which order should the attribute be used to sort the items."),
          numericInput(inputId = ns("w_sort_rank"),
                       label = "Rank",
                       value = value_rank,
                       min = 0,
                       max = NA,
                       step = 1),

          # -- desc
          p("Whether ordering should be ascending or descending."),
          radioButtons(inputId = ns("w_sort_desc"),
                       label = "Direction",
                       choices = c("asceding" = FALSE, "descending" = TRUE),
                       selected = value_desc)))

      } else
        output$w_sort_details <- NULL

    })


    # ---------------------------------
    # Step.5: confirm create
    # ---------------------------------

    # -- observer actionButton
    observeEvent(input$w_ask_confirm, {

      # -- Close window
      removeModal()
      cat("[step.5] Ask for confirmation \n")

      # -- display modal
      showModal(modalDialog(

        # -- body
        tagList(

          h4("Step 5:"),
          p("Review and confirm attribute", ifelse(isUpdate(), "update.", "creation.")),

          # -- set ordering
          tags$ul(
            tags$li("name =", input$w_name),
            tags$li("type =", input$w_type),
            tags$li("default strategy =", input$w_default_choice),
            if(input$w_default_choice == "val")
              tags$ul(
                tags$li("Value =", input$w_default_val)),
            if(input$w_default_choice == "fun")
              tags$ul(
                tags$li("Function =", input$w_default_fun),
                tags$li("Arguments =", ifelse(input$w_default_arg == "", "(empty)", input$w_default_arg))),
            tags$li("skip =", input$w_skip),
            tags$li("filter =", input$w_filter),
            tags$li("Ordering =", input$w_sort),
            if(input$w_sort)
              tags$ul(
                tags$li("Rank =", input$w_sort_rank),
                tags$li("Direction =", input$w_sort_desc)),

            )),

        # -- params
        title = "Attribute setup assistant",
        footer = tagList(
          modalButton("Cancel"),
          actionButton(inputId = ns("w_confirm"), paste("Confirm", ifelse(isUpdate(), "update", "create"))))))

    })


    # ---------------------------------
    # Step.6: create
    # ---------------------------------

    # -- observer actionButton
    observeEvent(input$w_confirm, {

      # -- Close window
      removeModal()
      cat("[step.6] Confirm, operation =", ifelse(isUpdate(), "update", "create"), "\n")

      # -- get the data model
      dm <- k_data_model()

      # -- check
      dm <- if(isUpdate()){

        # -- get attribute to update
        attribute <- k_data_model()[input$data_model_rows_selected, ]

        # -- prepare values
        # only values to be updated will be not NULL

        # -- default val
        default_val <- NULL
        if(input$w_default_choice == "val")
          if(input$w_default_val != attribute$default.val)
            default_val <- input$w_default_val

        # -- default fun & arg
        default_fun <- NULL
        default_arg <- NULL
        if(input$w_default_choice == "fun"){

          if(input$w_default_fun != attribute$default.fun)
            default_fun <- input$w_default_fun

          if(input$w_default_arg != attribute$default.arg)
            default_arg <- input$w_default_arg}

        # -- skip & filter
        skip <- if(input$w_skip != attribute$skip) input$w_skip else NULL
        filter <- if(input$w_filter != attribute$filter) input$w_filter else NULL

        # -- ordering
        sort_rank <- NULL
        sort_desc <- NULL
        if(input$w_sort){
          if(input$w_sort_rank != attribute$sort.rank)
            sort_rank <- input$w_sort_rank
          if(input$w_sort_desc != attribute$sort.desc)
            sort_desc <- input$w_sort_desc}

        # -- Update attribute
        dm_update_attribute(data.model = dm,
                            name = attribute$name,
                            default.val = default_val,
                            default.fun = default_fun,
                            default.arg = default_arg,
                            skip = skip,
                            filter = filter,
                            sort.rank = sort_rank,
                            sort.desc = sort_desc)

      } else

        # -- Add attribute to the data model
        dm_add_attribute(data.model = dm,
                         name = input$w_name,
                         type = input$w_type,
                         default.val = if(input$w_default_choice == "val") stats::setNames(input$w_default_val, input$w_name) else NULL,
                         default.fun = if(input$w_default_choice == "fun") stats::setNames(input$w_default_fun, input$w_name) else NULL,
                         default.arg = if(input$w_default_choice == "fun") stats::setNames(input$w_default_arg, input$w_name) else NULL,
                         skip = if(input$w_skip) input$w_name else NULL,
                         filter = if(input$w_filter) input$w_name else NULL,
                         sort.rank = if(input$w_sort) stats::setNames(input$w_sort_rank, input$w_name) else NULL,
                         sort.desc = if(input$w_sort) stats::setNames(input$w_sort_desc, input$w_name) else NULL)

      # -- store
      cat("[step.6] Update data model \n")
      k_data_model(dm)

      # -- Add column to items (create attribute only)
      if(!isUpdate()){

        # -- get default value
        value <- dm_get_default(data.model = dm, name = input$w_name)

        # -- Add column to items & store
        cat("[step.6] Add new attribute to existing items \n")
        items <- item_add_attribute(k_items(), name = input$w_name, type = input$w_type, fill = value)
        k_items(items)

      } else isUpdate(FALSE) # -- reset update

    })


    # --------------------------------------------------------------------------
    # Data model row select
    # --------------------------------------------------------------------------

    # -- observe data_model selected row
    observeEvent(input$data_model_rows_selected, {

      # -- get selected row
      row <- input$data_model_rows_selected

      # -- check out of limit value #272
      # If last row is selected and attribute is deleted, a crash would occur
      if(!is.null(row))
        if(row > nrow(k_data_model()))
          row <- NULL

      # -- check NULL (no row selected)
      if(is.null(row))

        # -- update output
        output$update_attribute <- NULL

      else

        # -- update output
        # set custom value for w_set_default input to trigger step.2 of the wizard
        output$update_attribute <- renderUI(actionButton(inputId = ns("update_attribute"),
                                                         label = "Update attribute",
                                                         onclick = sprintf('Shiny.setInputValue(\"%s\", "update", {priority: \"event\"})',
                                                                           ns("w_set_default"))))





    }, ignoreNULL = FALSE, ignoreInit = TRUE)


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

      # -- Check:
      # all columns need to be in the selection
      # order must be different from the one already in place
      req(length(input$dm_order_cols) == dim(k_items())[2],
          !identical(input$dm_order_cols, k_data_model()$name))

      cat("[BTN] Reorder column \n")

      # -- Reorder items & store
      k_items(k_items()[input$dm_order_cols])

      # -- Reorder data model & store
      dm <- k_data_model()
      dm <- dm[match(input$dm_order_cols, dm$name), ]
      k_data_model(dm)

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

      # -- check to avoid useless updates
      dm <- k_data_model()
      req(!setequal(input$adm_filter_col,dm[dm$filter, ]$name))

      cat(MODULE, "Set filtered attributes:", input$adm_filter_col, "\n")

      # -- Check NULL data model
      if(!is.null(dm)){
        dm <- dm_filter(data.model = dm, set = input$adm_filter_col)
        k_data_model(dm)}

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # --------------------------------------------------------------------------
    # Create item:
    # --------------------------------------------------------------------------

    # -- Declare: create_btn
    output$create_btn_output <- renderUI(

      # -- Check data model #290
      if(!is.null(k_data_model()))
            actionButton(inputId = ns("create_btn"),
                         label = "Create"))


    # -- Observe: create_btn
    observeEvent(input$create_btn,

          showModal(modalDialog(inputList(ns, item = NULL, update = FALSE, data.model = k_data_model()),
                                title = "Create",
                                footer = tagList(
                                  modalButton("Cancel"),
                                  actionButton(ns("confirm_create_btn"), "Create")))))


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
      if(is.null(selected_items()) | length(selected_items()) != 1)
        NULL
      else
        actionButton(inputId = ns("update_btn"),
                     label = "Update"))


    # -- Observe: update_btn
    observeEvent(input$update_btn, {

      cat(MODULE, "[EVENT] Update item \n")

      # -- Get selected item
      item <- k_items()[k_items()$id == selected_items(), ]

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
      input_values$id <- selected_items()

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = k_data_model())

      # -- update item & store
      cat("--  Update item \n")
      item_update(k_items, item, name = id)

    })


    # --------------------------------------------------------------------------
    # Delete item(s):
    # --------------------------------------------------------------------------

    # -- Declare: delete_btn
    output$delete_btn_output <- renderUI(

      # -- check item selection
      if(is.null(selected_items()))
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

      # -- get selected items (ids) & delete
      ids <- selected_items()
      item_delete(k_items, ids, name = id)

    })


    # --------------------------------------------------------------------------
    # Module server return value:
    # --------------------------------------------------------------------------

    # -- the reference (not the value!)
    list(id = id,
         url = items_url,
         items = k_items,
         data_model = k_data_model,
         filtered_items = filtered_items,
         selected_items = selected_items,
         clicked_column = clicked_column,
         filter_date <- filter_date)

  })
}

