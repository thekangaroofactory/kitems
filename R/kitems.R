

#' Kitems Module Server
#'
#' @description
#' This is the main component of the package.
#'
#' @param id the id to be used for the module server instance.
#' @param path where the data model and items are stored (see details).
#' @param trigger a reactive object to pass workflow events to the module (see details).
#' @param filter a reactive object to pass filters to the module (see details).
#' @param options a list of options (see details).
#'
#' @import shiny
#' @importFrom ktools catl
#' @importFrom rlang .data
#'
#' @export
#'
#' @returns the module server function returns a list of the reactive references that are accessible outside the module.
#' All elements except `id` & `url` are references to reactive values.
#' - id = the `id` of the module (same as the input argument)
#' - items = the reference of the items reactive
#' - data_model = the data model of the item group
#' - filtered_items = the reference of the filtered items reactive
#' - selected_items = the reference of the selected items (ids)
#' - clicked_column = the reference of the clicked column reactive
#' - filters = the reference of the reactive list with filter expressions.
#'
#' @details
#' The recommended way to define the `path` argument is to set the R_KITEMS_PATH
#' environment variable.
#'
#' Behavior of the module server can be tuned using a list of options:
#' - `autosave` option is a logical whether the item auto save should be activated or not (default = `TRUE`).
#' - `notify` option is a logical if Shiny notifications should be displayed (default = `TRUE`)
#'
#' If autosave option is `FALSE`, the `item_save()` function should be used to make the data persistent.
#'
#' Triggers are the way to send events for the module to execute dedicated actions.
#' `trigger` must be a reactive (or `NULL`, the default). An event is defined as a named list of the form
#' `list(workflow = "create", type = "dialog")` or `list(workflow = "create", type = "task", values = list(...))`
#' If `NULL`, the trigger manager will not be initialized.
#'
#' `filter` is a reactive object reference to pass filter expression(s) to the module server
#' A filter is defined as a named list: `list(layer = c("pre", "main"), expr = ...)`.
#' If `NULL`, the filter manager will not be initialized.
#'
#' @examples
#' \dontrun{
#' kitems(id = "mydata")
#' }

# -- Shiny module server logic -------------------------------------------------
kitems <- function(id, path = Sys.getenv("R_KITEMS_PATH"),
                   trigger = NULL, filter = NULL,
                   options = list(autosave = TRUE,
                                  notify = TRUE)) {

  moduleServer(id, function(input, output, session) {

    # //////////////////////////////////////////////////////////////////////////
    # -- Warm up ----

    ## -- Set trace level
    if(Sys.getenv("R_KITEMS_DEBUG") != "")
      ktools::trace_level(as.numeric(Sys.getenv("R_KITEMS_DEBUG")))

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    catl(MODULE, "Starting kitems module server...", debug = 1)

    # -- Get namespace
    ns <- session$ns


    # //////////////////////////////////////////////////////////////////////////
    # -- Check path ----

    # -- check path
    check_path(path)


    # //////////////////////////////////////////////////////////////////////////
    # -- Check other parameters ----

    # -- check trigger
    if(!is.null(trigger))
      stopifnot("trigger must be a reactive object" = is.reactive(trigger))

    # -- check filter
    if(!is.null(filter))
      stopifnot("filter must be a reactive object" = is.reactive(filter))

    # -- check options
    stopifnot("options argument must be a list" = is.list(options))

    # -- check elements in option list
    options <- ktools::match.option(fun = kitems, arg = "options", value = options)
    stopifnot("autosave option must be a logical" = is.logical(options$autosave))


    # //////////////////////////////////////////////////////////////////////////
    # -- Declare reactive objects ----

    # -- Internal workflow triggers
    #if(!is.null(trigger)){
    trigger_create_dialog <- reactiveVal(NULL)
    trigger_create_values <- reactiveVal(NULL)
    trigger_update_dialog <- reactiveVal(NULL)
    trigger_update_values <- reactiveVal(NULL)
    trigger_delete_dialog <- reactiveVal(NULL)
    trigger_delete_values <- reactiveVal(NULL)
    #}

    # -- Internal filter triggers
    #if(!is.null(filter)){
    trigger_filter_pre <- reactiveVal(NULL)
    trigger_filter_main <- reactiveVal(NULL)
    #}


    # //////////////////////////////////////////////////////////////////////////
    # -- Initialize data model and items ----

    ## -- Init item name / id
    # to allow attribute skip in grammar level function calls
    item <- id

    withProgress(message = MODULE, value = 0, {

      # -- init progress
      incProgress(0/4, detail = "Init")

      ## -- Load & check config ------------------------------------------------

      # -- read file
      config <- config_read(path)
      if(is.null(config))
        stop("No _kitems.yml configuration file found.\nCheck provided path.")

      # -- check version
      # config version must be same as package
      if(config$version != utils::packageVersion("kitems")){

        # -- display message
        showModal(
          modalDialog(
            title = "Kitems Version",
            p("Kitems config requires an update since package version is different."),
            p("Run kitems::admin() to fix it."),
            footer = actionButton(inputId = ns("dm_version_warning"), label = "Close app")))

        # -- listen to modal close button
        observeEvent(input$dm_version_warning, stopApp(), once = TRUE)}

      # -- Increment progress
      incProgress(1/4, detail = "Read items")


      ## -- Read the data (items) ----------------------------------------------

      # -- url from module id
      k_items_url <- name(id, url = T)

      # -- Init (non persistent object)
      init_items <- NULL

      # path = NULL as temporary workaround (it's contained in k_items_url)
      init_items <- item_load(connector = list(file = k_items_url,
                                               path = NULL),
                              col.classes = ci_classes(config, item))

      # -- Increment progress
      incProgress(2/4, detail = "Check items")


      # -- Check items integrity -----------------------------------------------

      if(!is.null(init_items)){
        catl(MODULE, "Checking items integrity")

        rc <- init_items |> check(config, item)
        if(length(rc))
            # -- when interactive
            if(isRunning()){
              showModal(
                modalDialog(
                  title = "Items Integrity",
                  p("Items require", length(rc), "recovery action(s)."),
                  p("Run admin() to fix it."),
                  footer = actionButton(inputId = ns("close_app"), label = "Close app")))
              observeEvent(input$close_app, stopApp(), once = TRUE)}}

      # Increment progress
      incProgress(3/4, detail = "Wrap everything")


      # -- Store into reactive values ------------------------------------------

      # -- data model
      # item config up to the data.model level
      k_data_model <- c_extract(config, item = item)$data.model

      # -- items
      k_items <- reactiveVal(init_items)
      rm(init_items)

      # Increment progress
      incProgress(4/4, detail = "Load items done")

    }) #end withProgress


    # //////////////////////////////////////////////////////////////////////////
    # -- Auto save ----
    # only for the items (config is managed in Admin Console)

    # -- declare listener (conditional)
    if(options$autosave)
      observeEvent(k_items(), {

        # -- secure #596
        req(is.data.frame(k_items()) || is.null(k_items()))

        # -- case when items has been deleted
        if(is.null(k_items()))
          if(file.exists(k_items_url)){
            success <- unlink(k_items_url)
            if(success == 1) warning("Item file could not be deleted. Delete it manually.")}
        else
          item_save(data = k_items(), connector = list(file = k_items_url))

        catl(MODULE, "[EVENT] Item list has been (auto) saved")

      }, ignoreNULL = FALSE, ignoreInit = TRUE)


    # //////////////////////////////////////////////////////////////////////////
    ## -- Event manager (trigger) ----

    if(!is.null(trigger))
      event_manager <- observe({

        # -- get event & check
        event <- trigger()
        stopifnot("Event should be a list object" = is.list(event))

        # -- check for multiple events
        if(all(sapply(event, is.list))){

          catl(MODULE, "Multiple events received, nb =", length(event))

          # -- only 1st element in event is kept
          event <- event[[1]]

          # -- listen for the items to be updated
          # then update trigger() without first element to fire again event_manager
          # run once!
          observeEvent(k_items(), {

            # -- drop first element or set NULL
            trigger(
              if(length(trigger()) > 1) trigger()[-1] else NULL)

          }, ignoreInit = TRUE, once = TRUE)

        }

        # -- check
        stopifnot("Event should contain workflow & type named elements" = all(c("workflow", "type") %in% names(event)))
        catl(MODULE, "[Event] received, workflow =", event$workflow, "/ type =", event$type, "\n")

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
    ## -- Event manager (filter) ----

    if(!is.null(filter))
      filter_manager <- observe({

        # -- get event & check
        event <- filter()
        stopifnot("Event should be a list object" = is.list(event))
        stopifnot("Event should contain layer & expr named elements" = all(c("layer", "expr") %in% names(event)))
        catl(MODULE, "[Event] New filter received, layer =", event$layer, "/ expr =", as.character(event$expr))

        # -- fire listeners
        if(event$layer == "pre")
          trigger_filter_pre(event$expr)

        if(event$layer == "main")
          trigger_filter_main(event$expr)

      }) |> bindEvent(filter(),
                      ignoreInit = FALSE)


    # //////////////////////////////////////////////////////////////////////////
    ## -- Create item workflow ----

    # -- Declare: actionButton output
    output$item_create_btn <- renderUI(

      # -- Check data model #290
      if(!is.null(k_data_model))
        actionButton(inputId = ns("item_create"),
                     label = "Create"))


    # -- Observe: fire create dialog
    observe({

      catl(MODULE, "[Event] Show create item dialog")

      # -- show create dialog
      config |>
        yaml_to_dm(name, type, default, values) |>
        dplyr::filter(name %in% included(config, item)) |>
        dm_default() |>
        item_form(ns = ns) |>
        item_dialog(workflow = "create", ns = ns)

    }) |> bindEvent(input$item_create, if(!is.null(trigger)) trigger_create_dialog(), ignoreInit = TRUE)


    # -- Observe: create item from dialog values
    observeEvent(input$item_create_confirm, {

      catl(MODULE, "[Event] Confirm create dialog item")
      removeModal()

      # -- Secure workflow
      tryCatch({

        # -- insert & store
        k_items(input |>
                  item_input_values(colClasses = ci_classes(config, item)) |>
                  attribute_values(data.model = yaml_to_dm(config, name, type, default, class.arg)) |>
                  rows_insert(items = k_items()))

        # -- notify
        if(options$notify)
          showNotification(paste(MODULE, "Item created."), type = "message")

      },

      # -- failed
      error = function(e) {

        # -- print & notify
        warning(paste("Item has not been created. \n error =", e$message))
        if(options$notify)
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
          k_items(trigger_create_values() |>
                    prepare_values(config = config) |>
                    attribute_values(data.model = yaml_to_dm(config, name, type, default, class.arg)) |>
                    rows_insert(items = k_items()))

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
      s_item <- k_items()[k_items()$id == selected_items(), ]

      # -- show update dialog
      s_item |>
        as_default(data.model = yaml_to_dm(config, name, type, default, values)) |>
        item_form(ns = ns) |>
        item_dialog(workflow = "update", ns = ns)

      })


    # -- Observe: fire update dialog from trigger
    if(!is.null(trigger))
      observe({

        catl(MODULE, "[Event] Update item dialog trigger")

        # -- Make sure value contains a single id
        req(length(trigger_update_dialog()) == 1)

        # -- Get selected item
        s_item <- k_items()[k_items()$id == trigger_update_dialog(), ]

        # -- show update dialog
        s_item |>
          as_default(data.model = yaml_to_dm(config, name, type, default, values)) |>
          item_form(ns = ns) |>
          item_dialog(workflow = "update", ns = ns)

      }) |> bindEvent(trigger_update_dialog(),
                      ignoreInit = TRUE)


    # -- Observe: update item from dialog
    observeEvent(input$item_update_confirm, {

      # -- close modal
      catl(MODULE, "[Event] Confirm update item button")
      removeModal()

      # -- get named list of input values
      catl("- Get list of input values")
      values <- item_input_values(input, ci_classes(config, item))

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
          values |>
            attribute_values(data.model = yaml_to_dm(config, name, type, default, class.arg), update = TRUE) |>
            rows_update(items = k_items()))

        # -- notify
        if(options$notify)
          showNotification(paste(MODULE, "Item updated."), type = "message")},

        # -- failed
        error = function(e) {

          # -- print & notify
          warning(paste("Item update has failed. \n error =", e$message))
          if(options$notify)
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
            trigger_update_values() |>
              prepare_values(config = config, update = TRUE) |>
              attribute_values(data.model = yaml_to_dm(config, name, type, default, class.arg), update = TRUE) |>
              rows_update(items = k_items()))

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

        if(options$notify)
          showNotification(paste(MODULE, "Item(s) deleted."), type = "message")},

        # -- failed
        error = function(e) {

          warning(paste("Item(s) has not been deleted. \n error =", e$message))
          if(options$notify)
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

        # -- get ids to delete
        ids <- trigger_delete_values()
        if(is.list(ids))
          ids <- unlist(ids)

        # -- Secure against errors
        tryCatch({

          # -- store new items table
          k_items(
            rows_delete(items = k_items(),
                        id = ids))

          if(options$notify)
            showNotification(paste(MODULE, "Item(s) deleted."), type = "message")},

          # -- failed
          error = function(e) {

            warning(paste("Item(s) has not been deleted. \n error =", e$message))
            if(options$notify)
              showNotification(paste(MODULE, "Item(s) not deleted."), type = "error")

          })

        # -- reset values
        # otherwise you can't update same object twice
        trigger_delete_values(NULL)

      }) |> bindEvent(trigger_delete_values(),
                      ignoreInit = TRUE)


    # //////////////////////////////////////////////////////////////////////////
    # -- Date slider ----
    # As of v0.7.1 the date slider min / max are computed based
    # on prefiltered_items() instead of k_items() #496

    # -- check if date slider widget is in the UI #591
    has_date_slider <- isolate("date_slider" %in% names(input))

    ## -- Date slider ----
    if(has_date_slider)
      observe({

        # -- check data model
        req(has_date_attribute(config))

        catl(MODULE, "Update date sliderInput")
        catl("- strategy =", input$date_slider_strategy, level = 2)

        # -- Get min/max
        if(nrow(prefiltered_items()) > 0){

          min <- min(prefiltered_items()$date)
          max <- max(prefiltered_items()$date)

        } else {

          min <- Sys.Date()
          max <- min

        }

        # -- Set value
        # implement this_year strategy by default #211
        # keep this year after item is added #223 & #242
        value <- if(is.null(input$date_slider_strategy) || input$date_slider_strategy == "this-year")
          ktools::date_range(min, max, type = "this_year")
        else
          value <- input$date_slider

        # -- date slider
        # adding as.Date() to ensure they all have same format #521
        updateSliderInput(inputId = "date_slider",
                          min = as.Date(min),
                          max = as.Date(max),
                          value = as.Date(value))

      })


    # //////////////////////////////////////////////////////////////////////////
    # -- Filtering layers ----

    ## -- Pre-filtering layer ----
    # Only custom filter is applied at this level
    prefiltered_items <- reactive(

      # -- check custom filter
      if(!is.null(trigger_filter_pre())){

        # -- apply filter
        catl(MODULE, "Apply custom pre-filtering on items")

        # -- test must be done out of the filter() function #593
        # otherwise multiple confitions does not work
        items <- if(is.list(trigger_filter_pre()))
          k_items() |> dplyr::filter(!!!trigger_filter_pre())
        else
          k_items() |> dplyr::filter(!!trigger_filter_pre())
        catl("- ouput dim =", dim(items), level = 2)

        # -- return
        items

      } else k_items()) |> bindEvent(k_items(), trigger_filter_pre())


    ## -- Main-filtering layer ----
    # Custom filter + date filter / + ordering
    filtered_items <- reactive({

      # -- check for empty items (NULL or 0 obs.)
      req(prefiltered_items(), nrow(prefiltered_items()) > 0)

      catl(MODULE, "Apply custom filter(s) on items")

      # -- check date slider
      # note: force everything to be a Date #615
      date_expr <- if(has_date_attribute(config) && !is.null(input$date_slider)){
        catl("- Date slider =", input$date_slider, level = 2)
        dplyr::expr(as.Date(date) >= as.Date(input$date_slider[1]) & as.Date(date) <= as.Date(input$date_slider[2]))}

      # -- check custom filter
      if(!is.null(trigger_filter_main()))
        catl("- Custom filter =", as.character(trigger_filter_main()), level = 2)

      # -- merge expression(s)
      # NULLs will be supported, output is NULL, one expr or several exprs
      filter_exprs <- c(trigger_filter_main(), date_expr)

      # -- init
      items <- prefiltered_items()

      # -- apply filter(s)
      if(!is.null(filter_exprs)){
        # -- test must be done out of the filter() function #601
        # otherwise multiple confitions does not work
        items <- if(is.list(filter_exprs))
          k_items() |> dplyr::filter(!!!filter_exprs)
        else
          k_items() |> dplyr::filter(!!filter_exprs)
        catl("- ouput dim =", dim(items), level = 2)}

      # -- Apply ordering
      if(!is.null(organized(config)))
        items <- item_sort(items, config)

      # -- Return
      items

    }) |> bindEvent(prefiltered_items(), trigger_filter_main(), input$date_slider)


    # //////////////////////////////////////////////////////////////////////////
    # -- Filtered view ----

    ## -- Declare view ----
    output$filtered_view <- DT::renderDT(mask(item_reveal(filtered_items(), config)),
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
      cols <- colnames(mask(item_reveal(utils::head(filtered_items(), n = 1), config)))

      # -- Get name of the clicked column
      col_clicked <- cols[input$filtered_view_cell_clicked$col + 1]
      catl(MODULE, "Clicked column =", col_clicked, level = 2)

      # -- return
      col_clicked

    })


    # //////////////////////////////////////////////////////////////////////////
    # -- Module server return value ----

    # -- the reference (not the value!)
    list(id = id,
         items = reactive(k_items()),
         data_model = k_data_model,
         filtered_items = filtered_items,
         selected_items = selected_items,
         clicked_column = clicked_column,
         filters = reactive(
           list(
             pre = trigger_filter_pre(),
             main = trigger_filter_main(),
             date = input$date_slider)))

  })
}

