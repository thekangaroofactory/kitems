# Implementations

The framework is meant to be flexible, which means that several
implementations (in other words levels of delegation / control) have
been defined.

## Full delegation

In this scenario / implementation, the *item* management is only
performed through the module server & UI. This is the default mode.

- module server is launched without the `trigger` argument

- actions are performed using the UI components

Server example:

``` r
# -- Define server logic
shinyServer(
  function(input, output, session){
    
    # -- Launch module servers
    mydata <- kitems::kitems(id = "mydata", path = "./data")
    
  })
```

UI example:

``` r
# -- Define app UI
ui <- page_navbar(
  
  # -- misc
  id = "page",
  title = "kitems",
  
  # -- content
  nav_panel("Full delegation",
            
            # -- action buttons
            p("Here are the action buttons:"),
            kitems::create_widget("mydata"),
            kitems::update_widget("mydata"),
            kitems::delete_widget("mydata"),
            
            # -- filter
            p("Here is a date filter:"),
            kitems::date_slider_widget("mydata"),
            
            # -- view
            p("Here is the items table:"),
            kitems::filtered_view_widget("mydata")))
```

Create / update / delete operations will be fully managed by the module
server. A dialog will popup for the user to provide required inputs and
confirmation.

The date slider can be used to filter the data / *items* displayed in
the filtered view.

From there, you will use the `mydata` object (containing the module
server function return value) to perform your own tasks (build a plot on
the data for example).

## Mixed implementation

In this scenario, you may not want to implement the action buttons
provided in the package but still use the dialog capabilities of the
module. An example is when *item* creation will be launched as a side
effect of an observer in your app.

The module server will be launched using the `trigger` reactive argument
so that an event can be passed to fire the expected dialog.

Server example:

``` r
# -- Define server logic
shinyServer(
  function(input, output, session){
    
    # -- Define reactive trigger
    events <- reactiveVal()
    
    # -- Launch module servers
    mydata <- kitems::kitems(id = "mydata", path = "./data", trigger = events)
    
  })
```

Create item example:

``` r
# -- Observe some event
observeEvent(input$foo, {
  
  # -- fire the create item dialog
  events(
    list(workflow = "create", type = "dialog"))
  
})
```

> **Note**
>
> This implementation is also required when the *item* table view is not
> implemented in the app UI (because it is not possible to access the
> update / delete buttons when no row is selected in the *item* table).

## Full control

This scenario is say the opposite of the full delegation
implementation.  
It is meant to be mostly used when the *item* operations do not rely on
user interactions, hence it will be managed as pure back-end tasks.

A very good example for this use case is a GitHub client app that would
call the GitHub API to get issues related to a repository and store them
into a cache to avoid performance issues when multiple calls are
performed.

Another – maybe easier – example is a dashboard that would display a map
and user would create markers just by clicking on it.

The code implementation itself is not very different from the mixed
implementation as you will use the trigger to communicate to the module
server from the main / parent server.

Server example:

``` r
# -- Define server logic
shinyServer(
  function(input, output, session){
    
    # -- Define reactive trigger
    events <- reactiveVal()
    
    # -- Launch module servers
    mydata <- kitems::kitems(id = "mydata", path = "./data", trigger = events)
    
  })
```

But the *item* operations will no longer rely on the dialog, so you need
to pass all required information for the module server to perform the
task in the background.

Create item example:

``` r
# -- Observe some event
observeEvent(input$foo, {
  
  # -- fire the create item task
  events(
    list(workflow = "create", 
         type = "task", 
         values = list(date = Sys.Date(),
                       name = "North Curl Rockpool",
                       address = "Huston Parade, NSW 2099, Australia",
                       lat = -33.767445014347935,
                       lon = 151.30197071564936)))
    
    })
```

> **Important**
>
> This implementation is considered as an advanced scenario that is
> available to cover more complex use cases.
>
> It is important to read / understand about the workflows &
> communication topics before using it – especially when using
> **existing** data – as the module server will not ask for confirmation
> to perform delete operations for example.

## Useful links

- workflows

- shiny module

- communication
