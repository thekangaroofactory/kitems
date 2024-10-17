

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
#' kitems_server(id = "mydata", path = "path/to/my/data",
#'               create = TRUE, autosave = TRUE)
#' }


# -- Shiny module server logic -------------------------------------------------

kitems_server <- function(id, path,
                                 create = TRUE, autosave = TRUE) {

  moduleServer(id, function(input, output, session) {

    # __________________________________________________________________________
    # -- Init app environment --------------------------------------------------

    ## -- Declare config parameters ----

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    cat(MODULE, "Starting kitems module server... \n")

    # -- Get namespace
    ns <- session$ns


    ## -- Declare objects ----

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

    # -- Check path (to avoid connection problems if missing folder)
    if(!dir.exists(path))
      dir.create(path)


    # __________________________________________________________________________
    # -- Initialize data model and items ---------------------------------------

    # -- Notify progress
    withProgress(message = MODULE, value = 0, {

      ## -- Read data model ----------------------------------------------------

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

      # -- Increment the progress bar, and update the detail text.
      incProgress(1/4, detail = "Read data model")


      # -- Read the data (items) ----------------------------------------------

      # -- Check for NULL data model (then no reason to try loading)
      if(!is.null(init_dm))

        init_items <- item_load(data.model = init_dm,
                           file = items_url,
                           path = path,
                           create = create)

      # -- Increment the progress bar, and update the detail text.
      incProgress(2/4, detail = "Read items")


      # -- Check data model integrity -----------------------------------------

      # -- Check for NULL data model + data.frame
      if(!is.null(init_dm) & !is.null(init_items)){

        cat(MODULE, "Checking data model integrity \n")
        result <- dm_integrity(data.model = init_dm, items = init_items, template = TEMPLATE_DATA_MODEL)

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


      # -- Check items integrity -----------------------------------------------

      # -- Check classes vs data.model
      if(!is.null(init_dm) & !is.null(init_items)){

        cat(MODULE, "Checking items classes integrity \n")
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
        cat(MODULE, "[EVENT] Data model has been (auto) saved \n")

      }, ignoreInit = TRUE)


    ## -- Items ----

    # -- Check parameter & observe items
    if(autosave)
      observeEvent(k_items(), {

        # -- Write
        item_save(data = k_items(), file = items_url)

        # -- Notify
        cat(MODULE, "[EVENT] Item list has been (auto) saved \n")

      }, ignoreInit = TRUE)


    # __________________________________________________________________________
    # -- Item management ----
    # __________________________________________________________________________
    ## -- Create item ----

    # -- Declare: create_btn
    output$create_btn_output <- renderUI(

      # -- Check data model #290
      if(!is.null(k_data_model()))
        actionButton(inputId = ns("create_btn"),
                     label = "Create"))


    # -- Observe: create_btn
    observeEvent(input$create_btn,

                 showModal(modalDialog(item_form(ns, item = NULL, update = FALSE, data.model = k_data_model()),
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
      input_values <- input_values(input, dm_colClasses(k_data_model()))

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = k_data_model())

      # -- update reactive
      item_add(k_items, item, name = id)

    })


    # __________________________________________________________________________
    ## -- Update item ----
    # __________________________________________________________________________

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
      showModal(modalDialog(item_form(ns, item = item, update = TRUE, data.model = k_data_model()),
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
      input_values <- input_values(input, dm_colClasses(k_data_model()))

      # -- update id (to replace selected item)
      input_values$id <- selected_items()

      # -- create item based on input list
      cat("--  Create item \n")
      item <- item_create(values = input_values, data.model = k_data_model())

      # -- update item & store
      cat("--  Update item \n")
      item_update(k_items, item, name = id)

    })


    # __________________________________________________________________________
    ## -- Delete item(s) ----
    # __________________________________________________________________________

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


    ## -- Observe date_slider input ----
    observeEvent(input$date_slider, {

      cat(MODULE, "Date sliderInput has been updated: \n")
      cat("-- values =", input$date_slider, "\n")

      # -- store
      filter_date(input$date_slider)

    })


    # __________________________________________________________________________
    # -- Filtered items --------------------------------------------------------

    ## -- Declare filtered_items ----
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

        cat(MODULE, "Selected rows (filtered view) =", input$filtered_view_rows_selected, "\n")

        # -- Get item ids from the default view
        ids <- filtered_items()[input$filtered_view_rows_selected, ]$id
        cat("-- ids =", as.character(ids), "\n")

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
      cat(MODULE, "Clicked column (filtered view) =", col_clicked, "\n")

      # -- Store
      clicked_column(col_clicked)

    }, ignoreNULL = TRUE)


    # __________________________________________________________________________
    # -- Admin ----
    # __________________________________________________________________________

    # -- Call module
    admin_server(k_data_model, k_items, path, dm_url, items_url, autosave)


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
         filter_date <- filter_date)

  })
}

