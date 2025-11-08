

#' kitems Admin Server
#'
#' @param k_data_model the reference of the data model reactive value
#' @param k_items the reference of the item reactive value
#' @param path the path provided to the kitems server
#' @param dm_url the url of the data model file
#' @param items_url the url of the item file
#' @param autosave the autosave value passed to the kitems server
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' kitems_admin(
#' k_data_model = mydata$data_model,
#' k_items = mydata$items,
#' path = path,
#' dm_url = dm_url,
#' items_url = items_url,
#' autosave = autosave)
#' }


# -- Shiny module server logic -------------------------------------------------

kitems_admin <- function(k_data_model, k_items, path, dm_url, items_url, autosave) {

  # -- force set id to 'admin'
  id <- "admin"

  moduleServer(id, function(input, output, session) {

    # -- Init ------------------------------------------------------------------

    # -- Get namespace
    ns <- session$ns

    # -- Build log pattern
    MODULE <- paste0("[", substr(ns(""), 1, nchar(ns("")) - 1), "]")
    catl(MODULE, "Starting kitems admin module server...", debug = 1)

    # -- Declare internal reactives
    import_callback <- reactiveVal(NULL)
    attribute_callback <- reactiveVal(NULL)


    # -- Admin tables ---------------------------------------------------------

    ## -- Data model table ----
    # setting rownames = FALSE #209
    # setting dom = "tpl" instead of "t" #245
    # allowing display all #244
    output$dm_table <- DT::renderDT(dm_mask(k_data_model()),
                                    rownames = FALSE,
                                    options = list(lengthMenu = list(c(20, 50, -1), c('20', '50', 'All')),
                                                   pageLength = 20, dom = "tpl", scrollX = TRUE),
                                    selection = list(mode = 'single', target = "row", selected = isolate(input$dm_table_rows_selected)))

    ## -- Raw item table ----
    output$raw_table <- DT::renderDT(k_items(),
                                     rownames = FALSE,
                                     options = list(lengthMenu = c(5, 10, 15), pageLength = 5, dom = "t", scrollX = TRUE),
                                     selection = list(mode = 'single', target = "row", selected = NULL))

    ## -- Masked item view ----
    output$masked_table <- DT::renderDT(item_mask(k_data_model(), k_items()),
                                        rownames = FALSE,
                                        selection = list(mode = 'single', target = "row", selected = NULL))


    # -- Admin inputs ---------------------------------------------------------

    ## -- Sort inputs ----
    output$dm_sort <- renderUI(

      # -- check NULL data model
      if(is.null(k_data_model()))
        NULL

      else {

        tagList(

          # order attribute name
          selectizeInput(inputId = ns("dm_sort"),
                         label = "Select cols order",
                         choices = k_data_model()$name,
                         selected = k_data_model()$name,
                         multiple = TRUE))})


    ## -- display inputs ----
    output$dm_att_display <- renderUI(

      # -- check NULL data model
      if(is.null(k_data_model()))
        NULL

      else {

        # -- init params
        filter_cols <- dm_display(k_data_model())

        onInitialize <- if(is.null(filter_cols))
          I('function() { this.setValue(""); }')
        else
          NULL

        # -- define input
        selectizeInput(inputId = ns("dm_display"),
                       label = "Hide columns",
                       choices = k_data_model()$name,
                       selected = filter_cols,
                       multiple = TRUE,
                       options = list(create = FALSE,
                                      placeholder = 'Type or select an option below',
                                      onInitialize = onInitialize))})


    # -- Admin tabs -----------------------------------------------------------

    ## -- Data model tab ----
    output$dm_tab <- renderUI({

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

                        actionButton(ns("import"), label = "Import data")))

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
                          DT::DTOutput(ns("dm_table")))),

          # -- actions
          fluidRow(column(width = 12,
                          h3("Actions"),
                          actionButton(inputId = ns("create_attribute"), label = "New attribute"),
                          uiOutput(ns("update_attribute")))),

          # -- info
          fluidRow(column(width = 12,
                          p(icon(name = "circle-info"), "Display can also be changed in the 'view' tab."))),

          # -- danger zone
          fluidRow(column(width = 12,
                          br(),
                          uiOutput(ns("dz_toggle")),
                          uiOutput(ns("danger_zone")))))

      }

    })


    ## -- Raw table tab ----
    output$raw_tab <- renderUI({

      # -- check NULL data model
      if(!is.null(k_data_model())){

        # -- display raw table
        fluidRow(column(width = 2,
                        p("Actions"),
                        uiOutput(ns("dm_sort"))),

                 column(width = 10,
                        p("Raw Table"),
                        DT::DTOutput(ns("raw_table"))))

      }

    })


    ## -- Masked view tab ----
    output$masked_tab <- renderUI({

      # -- check NULL data model
      if(!is.null(k_data_model())){

        # -- display view table
        fluidRow(column(width = 2,
                        p("Actions"),
                        uiOutput(ns("dm_att_display")),
                        p("Column name mask applied by default:",br(),
                          "- replace dot, underscore with space",br(),
                          "- capitalize first letters")),

                 column(width = 10,
                        p("Filtered Table"),

                        # -- when all attributes are filtered #358
                        conditionalPanel(
                          condition = (paste0("document.getElementById(\"", ns("masked_table"), "\").children.length==0")),
                          p("All attributes are filtered, the table is empty.")),

                        DT::DTOutput(ns("masked_table"))))

      }

    })


    # -- Observe admin tabs ---------------------------------------------------

    ## -- Data_model selected row ----
    observeEvent(input$dm_table_rows_selected, {

      # -- get selected row
      row <- input$dm_table_rows_selected

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
                                                         label = "Update attribute"))

    }, ignoreNULL = FALSE, ignoreInit = TRUE)


    ## -- Sort attributes / columns ----
    observeEvent(input$dm_sort, {

      # -- Check:
      # all columns need to be in the selection
      # order must be different from the one already in place
      req(length(input$dm_sort) == dim(k_items())[2],
          !identical(input$dm_sort, k_data_model()$name))

      catl("[BTN] Reorder column")

      # -- Reorder items & store
      k_items(k_items()[input$dm_sort])

      # -- Reorder data model & store
      dm <- k_data_model()
      dm <- dm[match(input$dm_sort, dm$name), ]
      k_data_model(dm)

    })


    ## -- Display/hide attributes ----
    observeEvent(input$dm_display, {

      # -- check to avoid useless updates
      dm <- k_data_model()
      req(!setequal(input$dm_display, dm[dm$display, ]$name))

      catl(MODULE, "Set hidden attributes:", input$dm_display)

      # -- Check NULL data model
      if(!is.null(dm)){
        dm <- dm_display(data.model = dm, set = input$dm_display)
        k_data_model(dm)}

    }, ignoreInit = TRUE, ignoreNULL = FALSE)


    # __________________________________________________________________________
    # -- Import data ----
    # __________________________________________________________________________

    ## -- Observe: click (start import) ----
    observeEvent(input$import, {

      catl(MODULE, "Import data \n")

      # -- call module server
      import_server(id = "import", k_data_model, k_items, callback = import_callback)})


    ## -- Observe: cleanup callback ----
    # Once the module server is executed, cleanup observers (inputs can't be removed)
    observeEvent(import_callback(), {

      # -- clean module observers
      session$userData$build_item_obs$destroy()
      session$userData$build_dm_obs$destroy()
      session$userData$confirm_import_obs$destroy()

      # -- reset callback
      import_callback(NULL)
      catl(MODULE, "Import module cleanup done")})


    # __________________________________________________________________________
    # -- Create data model ----
    # __________________________________________________________________________

    # -- Observe: actionButton
    observeEvent(input$dm_create, {

      catl("[BTN] Create data")

      # -- init parameters (id)
      # Implement template #220
      template <- TEMPLATE_DATA_MODEL[TEMPLATE_DATA_MODEL$name == "id", ]
      colClasses <- stats::setNames(template$type, template$name)
      default_val <- stats::setNames(template$default.val, template$name)
      default_fun <- stats::setNames(template$default.fun, template$name)
      display <- if(template$display) template$name else NULL
      skip <- if(template$skip) template$name else NULL

      # -- init data model & store
      catl(MODULE, "-- Building data model")
      dm <- data_model(colClasses = colClasses,
                       default.val = default_val,
                       default.fun = default_fun,
                       display = display,
                       skip = skip)

      # -- store
      k_data_model(dm)

      # -- init items
      catl(MODULE, "-- Init data")
      items <- ktools::create_data(colClasses = colClasses)

      # -- store items
      k_items(items)

    })


    # __________________________________________________________________________
    # Data model attribute wizard ----
    # __________________________________________________________________________

    # -- observe button
    # Added #281
    # call module #307
    observeEvent(input$create_attribute,
                 attribute_wizard_server(id = "wizard",
                                         k_data_model,
                                         k_items,
                                         update = FALSE,
                                         attribute = NULL,
                                         callback = attribute_callback))

    # -- observe button
    # call module #307
    observeEvent(input$update_attribute,
                 attribute_wizard_server(id = "wizard",
                                         k_data_model,
                                         k_items,
                                         update = TRUE,
                                         attribute = k_data_model()[input$dm_table_rows_selected, ],
                                         callback = attribute_callback))


    # -- observer callback
    observeEvent(attribute_callback(), {

      catl(MODULE, "Cleanup module observers", level = 2)
      session$userData$w_obs1$destroy()
      session$userData$w_obs2$destroy()
      session$userData$w_obs3$destroy()
      session$userData$w_obs4$destroy()
      session$userData$w_obs5$destroy()
      session$userData$w_obs6$destroy()
      session$userData$w_obs7$destroy()
      session$userData$w_obs8$destroy()
      session$userData$w_obs9$destroy()
      session$userData$w_obs10$destroy()
      session$userData$w_obs11$destroy()
      session$userData$w_obs12$destroy()
      session$userData$w_obs13$destroy()

      # -- reset
      attribute_callback(NULL)

    })


    # __________________________________________________________________________
    # -- Danger zone ----
    # __________________________________________________________________________

    ## -- Toggle btn ----
    output$dz_toggle <- renderUI(

      # -- Check for NULL data model
      if(!is.null(k_data_model()))
        shinyWidgets::materialSwitch(inputId = ns("dz_toggle_btn"),
                                     label = "Danger zone",
                                     value = FALSE,
                                     status = "danger"))


    ## -- Danger zone ui output ----
    output$danger_zone <- renderUI(

      # -- check toggle btn
      if(input$dz_toggle_btn)
        danger_zone_widget(k_data_model, ns)) %>%

      # -- event
      bindEvent(input$dz_toggle_btn, ignoreInit = TRUE)


    ## -- Delete attribute ------------------------------------------------------

    ### -- Observe button ----
    observeEvent(input$dz_delete_att, {

      # -- check data model size (to display warning)
      single_row <- nrow(k_data_model()) == 1

      # -- Open dialog for confirmation
      showModal(modalDialog(title = "Delete attribute",
                            p("Danger: deleting an attribute can't be undone! Do you confirm?"),
                            if(single_row) p("Note that the data model will be deleted since this is the last attribute."),
                            footer = tagList(
                              modalButton("Cancel"),
                              actionButton(ns("dz_delete_att_confirm"), "Delete"))))})


    ### -- Observe confirm button ----
    observeEvent(input$dz_delete_att_confirm, {

      # -- check & close modal
      req(input$dz_delete_att_name)
      catl("[BTN] Delete attribute:", input$dz_delete_att_name)
      removeModal()

      # -- perform delete
      attribute_delete(k_data_model,
                       k_items,
                       name = input$dz_delete_att_name,
                       MODULE,
                       autosave,
                       dm_url,
                       items_url,
                       notify = shiny::isRunning())})


    ## -- Delete data model ----------------------------------------------------

    ### -- Observe actionButton ----
    observeEvent(input$dz_delete_dm, {

      catl(MODULE, "Delete data model preview \n")

      # -- Open dialog for confirmation
      showModal(
        dm_delete_preview(hasItems = !is.null(k_items()),
                          dm.file = file.exists(dm_url),
                          item.file = file.exists(items_url),
                          autosave = autosave,
                          id = id,
                          ns = ns))})


    ### -- Observe confirm actionButton ----
    observeEvent(input$dz_delete_dm_confirm, {

      # -- check string & close modal
      req(input$dz_delete_dm_string == paste0("delete_", unlist(strsplit(ns(id), split = "-"))[1]))
      removeModal()
      catl(MODULE, "Delete data model confirmed!")

      # -- delete data model
      dm_delete(k_data_model, k_items, dm_url, items_url,
                autosave, item.file = input$dz_delete_dm_items)

      # -- notify
      if(shiny::isRunning())
        showNotification(paste(MODULE, "Data model deleted."), type = "warning")})

  })

}
