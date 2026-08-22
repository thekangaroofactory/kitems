

admin_attribute_wizard <- function(config, item, attribute = NULL, hide = FALSE, skip = FALSE, refresh = FALSE,
                                   callback, session = getDefaultReactiveDomain()){

  # ----------------------------------------------------------------------------
  # Init
  # ----------------------------------------------------------------------------

  # -- get inputs
  input <- session$input
  output <- session$output

  # -- check for update
  update <- !is.null(attribute)
  values <- if(update)
    config_extract(config, item, attribute)
  else
    list(name = "", type = NULL)
  values <- c(values, hide = hide, skip = skip, refresh = refresh)

  # -- compute reserved names
  # existing attributes (except itself for update)
  reserved <- config_attributes(config, item)
  if(update)
    reserved <- reserved[!reserved %in% attribute]


  # ----------------------------------------------------------------------------
  # Step.1 name
  # ----------------------------------------------------------------------------

  wizard_step_1 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      textInput(inputId = "attribute_name", label = "Name", value = values$name)))

    # -- validate
    obs <- observeEvent(input$attribute_name, {

      #-- init
      is_valid <- TRUE

      # -- rules
      # empty
      if(input$attribute_name == ""){
        is_valid <- FALSE
        output$w_validation <- renderUI(
          p(class = "text-danger", icon("circle-xmark"), "A name is required."))}

      # duplicate
      if(input$attribute_name %in% reserved){
        is_valid <- FALSE
        output$w_validation <- renderUI(
          p(class = "text-danger", icon("circle-xmark"), "This name already exists."))}

      # space(s)
      if(grepl(" ", input$attribute_name)){
        is_valid <- FALSE
        output$w_validation <- renderUI(
          p(class = "text-danger", icon("circle-xmark"), "Spaces are not allowed."))}

      # funny char(s)
      if(grepl("(?![_.-])[[:punct:]]", input$attribute_name, perl = TRUE)){
        is_valid <- FALSE
        output$w_validation <- renderUI(
          p(class = "text-danger", icon("circle-xmark"), "Only underscore, dash and dot are allowed."))}

      if(is_valid){
        output$w_validation <- renderUI(p(class = "text-success", icon("circle-check"), "The name is valid."))
        output$w_actions <- renderUI(actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))
      } else
        output$w_actions <- renderUI(NULL)

    })

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 1, listeners = obs)

  }


  # ----------------------------------------------------------------------------
  # Step.2 type & class.arg
  # ----------------------------------------------------------------------------

  wizard_step_2 <- function(){

    # -- trick to disable input
    x <- selectInput(inputId = "attribute_type",
                     label = "Type",
                     choices = OBJECT_CLASS,
                     selected = values$type)

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      if(update) shinyjs::disabled(x) else x,
                      bslib::input_switch(id = "attribute_allow_class_arg",
                                          label = "Class argument(s)",
                                          value = if(is.null(values$class.arg)) FALSE else TRUE),
                      div(id = "class-arg-content",
                          p("Class arguments are sent along with values to the as.* conversion function.", br(),
                            "ex: as.Date(34519, origin = '1904-01-01')"),
                          textInput(inputId = "attribute_class_arg",
                                    label = "Argument(s)",
                                    value = values$class.arg))))

    # -- listener
    # class.arg switch
    obs <- observeEvent(input$attribute_allow_class_arg, {

      if(input$attribute_allow_class_arg)
        shinyjs::show("class-arg-content")
      else
        shinyjs::hide("class-arg-content")

    })

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 2, listeners = obs)

  }


  # ----------------------------------------------------------------------------
  # Step.3 values
  # ----------------------------------------------------------------------------

  wizard_step_3 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      "Indicate possible values for an attribute.",
                      radioButtons(inputId = "attribute_values_verb",
                                   label = "",
                                   choices = list("any", "suggest", "limit", "lifecycle"),
                                   selected = if(is.null(values$values)) NULL else rlang::call_name(rlang::parse_expr(values$values)),
                                   inline = TRUE),
                      div(id = "attribute-values-container",
                          textInput(inputId = "attribute_values",
                                    label = "Values",
                                    value = if(is.null(values$values)) "" else paste(rlang::call_args(rlang::parse_expr(values$values)), collapse = ",")),
                          p("Use comma (,) between values."),
                          p("Behaviors:", br(),
                            tags$ul(
                              tags$li("suggest to let user chose among these values or set a different one,"),
                              tags$li("limit to force attribute choices among a given list of values,"),
                              tags$li("lifecycle to indicate values are states (with promote/demote mechanism)."))))))

    # -- listener
    # radio buttons
    obs <- observeEvent(input$attribute_values_verb, {

      if(input$attribute_values_verb == "any")
        shinyjs::hide("attribute-values-container")
      else
        shinyjs::show("attribute-values-container")

    })

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 3)

  }


  # ----------------------------------------------------------------------------
  # Step.4 default
  # ----------------------------------------------------------------------------

  wizard_step_4 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      "Setup a default for the attribute:",
                      textInput(inputId = "attribute_default",
                                label = "Default",
                                value = if(is.null(values$default)) "" else values$default),
                      p("Ex: 1, draft, Sys.Date()"),
                      p("The default is used to:",
                        tags$ul(
                          tags$li("init the item form,"),
                          tags$li("set a value when it's left empty,"),
                          tags$li("compute the value when attribute is skipped."))),
                      p("It can be a symbol or a call with ().")))

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 4)

  }


  # ----------------------------------------------------------------------------
  # Step.5 hide / skip & refresh
  # ----------------------------------------------------------------------------

  wizard_step_5 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      p("Should the attribute column be hidden in the item table?"),
                      checkboxInput(inputId = "attribute_hide", label = "Hide", value = values$hide),
                      p("Should the attribute be skipped in the item form?", br(),
                        "If so, its value will be computed based on defaults."),
                      checkboxInput(inputId = "attribute_skip", label = "Skip", value = values$skip),
                      div(id = "attribute-refresh-container",
                          style = if(!values$skip) "display: none;",
                          p("When the attribute is skipped, should it be refreshed upon item update?"),
                          checkboxInput(inputId = "attribute_refresh", label = "Refresh", value = values$refresh))))

    # -- listener
    # skip radio buttons
    obs <- observeEvent(input$attribute_skip, {

      if(input$attribute_skip)
        shinyjs::show("attribute-refresh-container")
      else
        shinyjs::hide("attribute-refresh-container")

    })

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_next", label = "Next", icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 5, listeners = obs)

  }


  # ----------------------------------------------------------------------------
  # Step.5 confirmation
  # ----------------------------------------------------------------------------

  wizard_step_6 <- function(){

    # -- init UI
    insertUI(selector = "#input-container",
             where = "afterBegin",
             ui = div(id = "input-content",
                      p("Attibute summary, please check the parameters:"),
                      tags$ul(
                        tags$li("Name: ", if(update && attribute == "id") attribute else input$attribute_name),
                        tags$li("Type: ", input$attribute_type)),
                      p("Additional behaviors, the attribute will be:"),
                      tags$ul(
                        tags$li(ifelse(input$attribute_hide, "Hidden", "Displayed"), "in the item table."),
                        if(input$attribute_skip)
                          tags$li("Skipped in the item form."))))

    # -- no validation is required
    output$w_actions <- renderUI(
      actionButton(inputId = "w_confirm",
                   label = paste(ifelse(update, "Update", "Create"), "Attribute"),
                   icon = icon("circle-chevron-right")))

    # -- store step
    session$userData$kitems$wizard$step <- list(id = 6)

  }


  # ----------------------------------------------------------------------------
  # Cleanup
  # ----------------------------------------------------------------------------

  cleanup <- function(wizard = FALSE, session = getDefaultReactiveDomain()){

    # -- cleanup modal UI
    output$w_validation <- renderUI(NULL)
    output$w_actions <- renderUI(NULL)
    removeUI(selector = "#input-content", immediate = TRUE)

    # -- helper: destroy observers
    helper <- function(obs){
      if(!is.null(obs)){
        if(is.list(obs))
          lapply(obs, function(x) x$destroy())
        else
          obs$destroy()}}

    # -- destroy step listeners
    helper(session$userData$kitems$wizard$step$listeners)

    # -- destroy wizard listeners
    if(wizard)
      helper(session$userData$kitems$wizard$listeners)

  }


  # ----------------------------------------------------------------------------
  # Next step
  # ----------------------------------------------------------------------------

  obs_next <- observeEvent(input$w_next, {

    # -- cleanup step
    cleanup()

    # -- launch next step
    get(paste0("wizard_step_", session$userData$kitems$wizard$step$id + 1))()

  }, ignoreInit = TRUE)

  # -- store
  session$userData$kitems$wizard$listeners <- obs_next


  # ----------------------------------------------------------------------------
  # Cancel wizard
  # ----------------------------------------------------------------------------

  observeEvent(input$w_cancel, {

    # -- cleanup UI
    removeModal()

    # -- cleanup wizard
    cleanup(wizard = TRUE)

    # -- cleanup userData
    session$userData$kitems[['wizard']] <- NULL

  }, ignoreInit = TRUE, once = TRUE)


  # ----------------------------------------------------------------------------
  # Final confirmation
  # ----------------------------------------------------------------------------

  obs_confirm <- observeEvent(input$w_confirm, {

    # -- cleanup UI
    removeModal()

    # -- cleanup wizard
    cleanup(wizard = TRUE)

    # -- cleanup userData
    session$userData$kitems[['wizard']] <- NULL

    # -- pass inputs to callback
    callback(
      list(name = if(update && attribute == "id") attribute else input$attribute_name,
           type = input$attribute_type,
           class.arg = input$attribute_class_arg,
           values = paste0(input$attribute_values_verb, "(", input$attribute_values, ")"),
           default = input$attribute_default,
           hide = input$attribute_hide,
           skip = input$attribute_skip,
           refresh = input$attribute_refresh))

  }, ignoreInit = TRUE, once = TRUE)

  # -- store
  session$userData$kitems$wizard$listeners <- c(session$userData$kitems$wizard$listeners, obs_confirm)


  # ----------------------------------------------------------------------------
  # Launch wizard
  # ----------------------------------------------------------------------------

  # -- init
  output$w_actions <- renderUI(NULL)
  showModal(
    admin_attribute_modal(update = update))

  # -- start
  if(update && attribute == "id")
    wizard_step_2()
  else
    wizard_step_1()

}
