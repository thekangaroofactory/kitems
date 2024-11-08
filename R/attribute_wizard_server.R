

# -- Shiny module server logic -------------------------------------------------

attribute_wizard_server <- function(id, k_data_model, k_items, update = FALSE, attribute = NULL, callback) {

  moduleServer(id, function(input, output, session) {

    # -- Init ------------------------------------------------------------------

    # -- Build log pattern
    MODULE <- paste0("[", id, "]")
    catl(MODULE, "Starting attribute wizard module server...", debug = 1)

    # -- Get namespace
    ns <- session$ns

    # -- Declare reactive values
    isValid <- reactiveValues()
    w_set_default <- reactiveVal(0)


    # -- Step.1: attribute name & type ----------------------------------------
    # Note: there is no need to support update in step.1

    if(update){

      catl(MODULE, "Update -- skip step.1")

      # -- init values
      isValid$name <- TRUE
      isValid$type <- TRUE

      # -- fire event
      w_set_default(w_set_default() + 1)


    } else {

      # -- init
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
          actionButton(inputId = ns("w_dismiss_1"), label = "Cancel",
                       onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                         ns("w_dismiss"))),
          actionButton(inputId = ns("w_confirm_step1"), label = "Next"))))


    } # if(update)


    # -- check attribute name
    session$userData$w_obs1 <- observeEvent(input$w_name, {

      # -- empty
      if(input$w_name == ""){

        name <- "xmark"
        style <- "color: #FFD43B;"
        msg <- "Attribute name is empty"
        isValid$name <- FALSE

      } else {

        # -- duplicatle name
        if(input$w_name %in% k_data_model()$name){

          name <- "circle-xmark"
          style <- "color: #ff0000;"
          msg <- "This attribute name is already used in the data model!"
          isValid$name <- FALSE

        } else {

          # -- blank space
          if(grepl(" ", input$w_name)){

            name <- "circle-xmark"
            style <- "color: #ff0000;"
            msg <- "Blank space is forbidden in attribute name!"
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

          }}}

      # -- note
      output$w_name_note <- renderUI(tagList(icon(name = name, class = "fa-solid", style = style), msg))

    }, ignoreInit = TRUE)


    # -- check attribute type
    session$userData$w_obs2 <- observeEvent(input$w_type, {

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

    }, ignoreInit = TRUE)


    # -- observe actionButton
    session$userData$w_obs3 <- observeEvent(input$w_confirm_step1, {

      # -- Requires valid name & type
      req(isValid$name & isValid$type)
      removeModal()

      # -- fire event
      w_set_default(w_set_default() + 1)

    }, ignoreInit = TRUE)


    # -- Step.2: defaults -----------------------------------------------------
    # entry point for the update process (step.1 skipped)

    # -- observe reactiveVal
    session$userData$w_obs4 <- observeEvent(w_set_default(), {

      # -- check (reactiveVal is init with 0)
      req(w_set_default() != 0)

      # -- init input values
      if(update){

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

      catl("[step.2] init: name =", name, "/ type =", type, "/ selected =", selected)

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
          actionButton(inputId = ns("w_dismiss_2"), label = "Cancel",
                       onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                         ns("w_dismiss"))),
          actionButton(inputId = ns("w_set_sf"), "Next"))))

    }, ignoreInit = FALSE)


    # -- Observe radioButtons
    session$userData$w_obs5 <- observeEvent(input$w_default_choice, {

      catl("[step.2] w_default_choice input =", input$w_default_choice, level = 2)

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
          if(update){

            value <- attribute$default.val

          } else { # -- create

            value <- DEFAULT_VALUES[[input$w_type]]}

          catl("[step.2] Set w_default_val: value =", value, level = 2)

          # -- update outputs
          output$w_default_detail <- renderUI(tagList(
            p("Rule: any value that can be coerced to the expected type"),
            textInput(inputId = ns("w_default_val"),
                      label = "Default value",
                      value = value,
                      placeholder = "Enter a valid value")))

        } else { # -- default function

          # -- setup input params
          if(update){

            choices <- unique(c(attribute$default.fun, DEFAULT_FUNCTIONS[[attribute$type]]))
            selected <- attribute$default.fun
            value <- attribute$default.arg

          } else { # -- create

            choices <- DEFAULT_FUNCTIONS[[input$w_type]]
            selected <- NULL
            value <- NULL}

          catl("[step.2] Set w_default_fun: selected =", selected, level = 2)

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

    }, ignoreInit = TRUE)


    # -- observe textInput (value)
    # takes w_default_choice to update messages upon radio change
    session$userData$w_obs6 <- observeEvent({
      input$w_default_choice
      input$w_default_val}, {

        # -- check
        if(input$w_default_choice == "val"){

          catl("[step.2] w_default_val =", input$w_default_val, level = 2)

          # -- empty
          if(input$w_default_val == ""){

            name <- "xmark"
            style <- "color: #FFD43B;"
            msg <- "Default value is empty"
            isValid$default_detail <- FALSE

          } else {

            # -- check update
            type <- if(update)
              attribute$type
            else
              input$w_type

            # -- try: coerce input to expected class
            catl("[step.2] Eval default value", level = 2)
            value <- trycatlch(
              eval(call(CLASS_FUNCTIONS[[type]], input$w_default_val)),
              error = function(e) e,
              warning = function(w) w)

            # -- check output
            if("error" %in% class(value)){

              catl("[Error]", value$message, debug = 1)
              name <- "circle-xmark"
              style <- "color: #ff0000;"
              msg <- paste("Default value is KO, error =", value$message)
              isValid$default_detail <- FALSE

            } else {

              if("warning" %in% class(value)){

                catl("[Warning]", value$message)
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

      }, ignoreInit = TRUE)


    # -- observe textInput (function & arg)
    # takes w_default_choice to update messages upon radio change
    session$userData$w_obs7 <- observeEvent({
      input$w_default_choice
      input$w_default_fun
      input$w_default_arg}, {

        # -- check
        if(input$w_default_choice == "fun"){

          catl("[step.2] w_default_fun =", input$w_default_fun, level = 2)
          catl("[step.2] w_default_arg =", input$w_default_arg, level = 2)

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
              catl("[step.2] Eval function arguments", level = 2)
              args <- trycatlch(eval(parse(text = input$w_default_arg)),
                               error = function(e) e,
                               warning = function(w) w)

              # -- check output
              if("error" %in% class(args))
                catl(args$message, debug = 1)

              else if("warning" %in% class(args))
                message(args$message)

            }

            # -- check update
            type <- if(update)
              attribute$type
            else
              input$w_type


            # -- try: call given function
            catl("[step.2] Eval function", level = 2)
            value <-  trycatlch(
              eval(call(CLASS_FUNCTIONS[[type]], eval(do.call(ktools::getNsFunction(input$w_default_fun), args = args)))),
              error = function(e) e,
              warning = function(w) w)

            # -- check output
            if("error" %in% class(value)){

              catl("[Error]", value$message, debug = 1)
              name <- "circle-xmark"
              style <- "color: #ff0000;"
              msg <- paste("Default funcion is KO, error =", value$message)
              isValid$default_detail <- FALSE

            } else {

              if("warning" %in% class(value)){

                catl("[Warning]", value$message)
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

      }, ignoreInit = TRUE)


    # -- Step.3: skip & filter ------------------------------------------------

    # -- observer actionButton
    session$userData$w_obs8 <- observeEvent(input$w_set_sf, {

      # -- Requires valid defaults
      req(isValid$default_detail)
      removeModal()

      # -- init input values
      if(update){

        value_skip <- attribute$skip
        value_filter <- attribute$filter

      } else {

        value_skip <- FALSE
        value_filter <- FALSE}

      catl("[step.3] init: skip =", value_skip, "/ filter =", value_filter)


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
          actionButton(inputId = ns("w_dismiss_3"), label = "Cancel",
                       onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                         ns("w_dismiss"))),
          actionButton(inputId = ns("w_set_sort"), "Next"))))

    }, ignoreInit = TRUE)


    # -- Step.4: order ---------------------------------------------------------

    # -- observer actionButton
    session$userData$w_obs9 <- observeEvent(input$w_set_sort, {

      # -- Close window
      removeModal()

      # -- init input params
      if(update){

        # -- get attribute
        value <- ifelse(is.na(attribute$sort.rank), FALSE, TRUE)

        # -- make sure options are correctly set
        if(value){
          updateNumericInput(inputId = "w_sort_rank",
                             value = attribute$sort.rank)

          updateRadioButtons(inputId = "w_sort_desc",
                             selected = attribute$sort.desc)}

      } else
        value <- FALSE

      catl("[step.4] init: ordering =", value)

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
          actionButton(inputId = ns("w_dismiss_4"), label = "Cancel",
                       onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                         ns("w_dismiss"))),
          actionButton(inputId = ns("w_ask_confirm"), "Next"))))

    }, ignoreInit = TRUE)


    # -- observe checkbox
    session$userData$w_obs10 <- observeEvent(input$w_sort, {

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

    }, ignoreInit = TRUE)


    ## -- Step.5: confirm create -----------------------------------------------

    # -- observer actionButton
    session$userData$w_obs11 <- observeEvent(input$w_ask_confirm, {

      # -- Close window
      removeModal()
      catl("[step.5] Ask for confirmation")

      # -- display modal
      showModal(modalDialog(

        # -- body
        tagList(

          h4("Step 5:"),
          p("Review and confirm attribute", ifelse(update, "update.", "creation.")),

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
          actionButton(inputId = ns("w_dismiss_5"), label = "Cancel",
                       onclick = sprintf('Shiny.setInputValue(\"%s\", this.id, {priority: \"event\"})',
                                         ns("w_dismiss"))),
          actionButton(inputId = ns("w_confirm"), paste("Confirm", ifelse(update, "update", "create"))))))

    }, ignoreInit = TRUE)


    ## -- Step.6: create / update ----------------------------------------------

    # -- observer actionButton
    session$userData$w_obs12 <- observeEvent(input$w_confirm, {

      # -- Close window
      removeModal()
      catl("[step.6] Confirm, operation =", ifelse(update, "update", "create"))

      # -- get the data model
      dm <- k_data_model()

      # -- check
      dm <- if(update){

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

          if(!identical(input$w_default_fun, attribute$default.fun))
            default_fun <- input$w_default_fun

          if(!identical(input$w_default_arg, attribute$default.arg))
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
        attribute_update(data.model = dm,
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
        attribute_create(data.model = dm,
                         name = input$w_name,
                         type = input$w_type,
                         default.val = if(input$w_default_choice == "val") stats::setNames(input$w_default_val, input$w_name) else NULL,
                         default.fun = if(input$w_default_choice == "fun") stats::setNames(input$w_default_fun, input$w_name) else NULL,
                         default.arg = if(input$w_default_choice == "fun") stats::setNames(input$w_default_arg, input$w_name) else NULL,
                         skip = if(input$w_skip) input$w_name else NULL,
                         filter = if(input$w_filter) input$w_name else NULL,
                         sort.rank = if(input$w_sort) stats::setNames(input$w_sort_rank, input$w_name) else NULL,
                         sort.desc = if(input$w_sort) stats::setNames(input$w_sort_desc, input$w_name) else NULL)

      # -- log
      catl("[step.6] Update data model", level = 2)

      # -- Add column to items (create attribute only)
      if(!update){

        # -- get default value
        value <- dm_default(data.model = dm, name = input$w_name)

        # -- Add column to items & store
        catl("[step.6] Add new attribute to existing items", level = 2)
        items <- item_migrate(k_items(), name = input$w_name, type = input$w_type, fill = value)

        # -- store #324
        k_items(items)
        k_data_model(dm)

      } else k_data_model(dm) # -- update


      # -- callback
      callback(TRUE)

    }, ignoreInit = TRUE)


    # -- observe actionButton (dismiss)
    session$userData$w_obs13 <- observeEvent(input$w_dismiss, {

      # -- close modal
      removeModal()
      catl(MODULE, "Dissmis attribute wizard =", input$w_dismiss)

      callback(TRUE)}, ignoreInit = TRUE)


  }) # moduleServer
}
