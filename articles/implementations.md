# Implementations

The framework is meant to be flexible, with several implementations
available.  
In other words, three levels of delegation / control have been defined:

- full delegation (the baseline)
- mixed implementation
- full control

> **Tip**
>
> It is recommended to read about these implementations to carefully
> chose the best approach given the project use case as some
> implementations require more advanced knowledge of R / Shiny.

## Full delegation

In this scenario / implementation, the management of the *items* is only
performed within the module.  
This is the default and most intuitive mode.

- Module server is launched from the main server
- Actions are performed using the module UI widgets implemented on
  client side.

This is why it is called “full delegation”.  
You don’t need to worry about how to manage those items.

Server example:

``` r

# -- Define server logic
shinyServer(
  function(input, output, session){
    
    # -- Launch the module server
    mydata <- kitems::kitems(id = "mydata")
    
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
            p("Here is the item table:"),
            kitems::item_widget("mydata")))
```

The module server will take care off everything:

- perform create / update / delete operations
- ask the required information / input to the user with dialog
- filter the data when the user selects a date range
- update the item table view

The behavior of the server will only depend on what’s defined in the
data model / YAML config.  
(which attribute to ask, what format to expect, what validation to
perform…).

From there, you can use the return value (`mydata` in the above example)
object to perform your own tasks (transform the data or build a plot for
example).

See
[shiny-module](https://thekangaroofactory.github.io/kitems/articles/shiny-module.html#return-values)
to read about the module server return value(s).

## Mixed implementation

In this scenario, you may not want to implement the action buttons
provided in the package but still use the dialog capabilities of the
module. An example is when *item* creation will be launched as a side
effect of an observer in your app instead of a click from the user.

The module server will be launched as before, but with the `trigger`
reactive argument so that an event can be passed to fire the expected
dialog.

Server example:

``` r

# -- Define server logic
shinyServer(
  function(input, output, session){
    
    # -- Define reactive trigger
    events <- reactiveVal()
    
    # -- Launch module servers
    mydata <- kitems::kitems(id = "mydata", trigger = events)
    
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

When the event is received by the module server, it will display the
same dialog to the user, based on the data model’s attributes.  
The same workflows are applied, but the way to trigger them is different
since it’s a server-server interaction.

> **Note**
>
> This implementation is also required when the *item* table view is not
> implemented in the app UI (because it is not possible to access the
> update / delete buttons when no row is selected in the *item* table).

## Full control

This scenario is say the opposite of the full delegation
implementation.  
It is meant to be used when the *item* operations do not rely on user
interactions, hence it will be managed as pure back-end tasks.

A very good example for this use case is an app that would call an API
and store the incoming data into a cache to avoid multiple duplicated
API calls. Then the app would pass the data to the module server trigger
to feed the cache without any user interaction.

Another – maybe easier – example is a dashboard that would display a map
and the user create markers just by clicking on it. The app server that
listen to the map click could send an event to the module server to
create a new marker *item*.

The code implementation itself is not very different from the mixed
implementation as you will use the `trigger` to communicate to the
module server from the main server.

Server example:

``` r

# -- Define server logic
shinyServer(
  function(input, output, session){
    
    # -- Define reactive trigger
    events <- reactiveVal()
    
    # -- Launch module servers
    mydata <- kitems::kitems(id = "mydata", trigger = events)
    
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
                       name = "North Curl Curl Rockpool",
                       address = "Huston Parade, NSW 2099, Australia",
                       lat = -33.767445014347935,
                       lon = 151.30197071564936)))
    
    })
```

The module server will perform the creation without asking for any input
or confirmation.

> **Important**
>
> This implementation is considered as an advanced scenario that is
> available to cover more complex use cases.
>
> It is important to read / understand about the
> [workflows](https://thekangaroofactory.github.io/kitems/articles/workflows.md)
> &
> [communication](https://thekangaroofactory.github.io/kitems/articles/communication.md)
> topics before using it – especially when using **existing** data – as
> the module server will not ask for confirmation to perform delete
> operations for example.

## Useful links

- Create / update / delete items –
  [workflows](https://thekangaroofactory.github.io/kitems/articles/workflows.md)
- Arguments & return value(s) –
  [shiny-module](https://thekangaroofactory.github.io/kitems/articles/shiny-module.md)
- Communication principles –
  [communication](https://thekangaroofactory.github.io/kitems/articles/communication.md)
