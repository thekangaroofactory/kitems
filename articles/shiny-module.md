# Shiny module

Although basic features are delivered as standard package functions, the
main component of the framework is a Shiny *module*.

## Motivation

All the data model and *item* related functions of the package can be
implemented in a Shiny App to manage your data model, create or update
*items*, display a table and so on.

But that would still require a lot of work to capture user inputs for
example to create a new *item* or manage the data persistence.

For this reason, the core functions are wrapped into a Shiny module that
handles all the reactive work. The module is meant to be very flexible
so that there is no need to code anything for basic use cases, but it
will let you take back control for more complex use cases (see
[implementations](https://thekangaroofactory.github.io/kitems/articles/implementations.md)).

## Server

The module server is delivered through the
[`kitems()`](https://thekangaroofactory.github.io/kitems/reference/kitems.md)
function.

### Arguments

The module server function accepts arguments to tune its behavior but
also reactive objects to communicate with the module (see
[communication](https://thekangaroofactory.github.io/kitems/articles/communication.md)).

> **Note**
>
> The whole module server approach is based on researches & work
> captured in the [Mastering Communication Between Shiny
> Modules](https://thekangaroofactory.github.io/communication-between-shiny-modules/)
> eBook.

#### Features

##### Autosave

By default, the module server will take care of the data persistence,
meaning any update of the data model or *items* will trigger a save.

This feature can be turned off:

``` r
kitems::kitems(id = "mydata", path = "./", autosave = FALSE)
```

This is useful when using *frozen* data that you don’t want to alter or
when your app needs to perform extra operations before save.

##### Admin

The admin tasks are wrapped into a dedicated module server (see
[admin](https://thekangaroofactory.github.io/kitems/articles/admin.md)).

``` r
kitems::kitems(id = "mydata", path = "./", admin = FALSE)
```

When the main module server is used in an admin context (mostly within
the Admin Console), this mode is turned ON.

#### Options

##### Shortcuts

The shortcut option activates the corresponding behavior.

``` r
kitems::kitems(id = "mydata", path = "./", options = list(shortcut = TRUE))
```

When it is activated, user will get shortcut values (suggestions) next
to the inputs in the item form.

See
[shortcuts](https://thekangaroofactory.github.io/kitems/articles/shortcuts.md)
article for more detail.

#### Reactive parameters

Some of the arguments (only) accept reactive objects as input.  
This is the basis of the communication architecture (see
[communication](https://thekangaroofactory.github.io/kitems/articles/communication.md)).

##### Trigger

This is the entry point to pass *item* workflow events to the module
server to perform create / update / delete tasks or get the
corresponding dialog.

See
[workflows](https://thekangaroofactory.github.io/kitems/articles/workflows.md)
to get a detailed description about how to use this argument.

##### Filter

This is the entry point to pass filtering events to the module server.

See
[filtering](https://thekangaroofactory.github.io/kitems/articles/filtering.md)
article to learn about the filters and how to set them.

### Return Values

The module server function returns a list of elements that can be
accessed from the outside.

``` r
my_data <- kitems::kitems(id = "mydata", path = "./")
```

Elements items, data_model, filtered_items, selected_items,
clicked_column and filters are reactive objects on which listeners
(observers) can take dependency to trigger actions at a higher level.

> Those reactive objects are defined with the
> [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)
> function inside the module server so that it is not possible to
> updated them from the outside. Item’s management should stick to the
> module server.

#### Data Model

The data model can be accessed **in a reactive context** from the return
value list:

``` r
# -- call module
mydata <- kitems::kitems(id = "mydata", path = "path/to/my/data")

# -- get data model (in a reactive context!)
data_model <- mydata$data_model()
```

#### Items

The *items* can be accessed **in a reactive context** from the return
value list:

``` r
# -- call module
mydata <- kitems::kitems(id = "mydata", path = "path/to/my/data")

# -- get items (in a reactive context!)
items <- mydata$items()
```

Items contains the full data frame of *items*, while filtered_items is
the output of the filtering layers and selected_items contains the ids
of the selected rows in the table.

#### Observe reactive values

The module server return value holds **references** to the reactives
values.  
Here is an example how to observe the *items*:

``` r
# -- Call module server
mydata <- kitems::kitems(id = "mydata", path = "./data")

# -- Observe items
observeEvent(mydata$items(), {
  print("Main application server: items object has just been updated.")
  # -- do something cool here
  })
```

See filtering
[considerations](https://thekangaroofactory.github.io/kitems/articles/filtering.html#considerations)
about listening to the `filtered_items` object.

## UI

To go along and communicate with the module server, a set of UI
components is delivered into dedicated functions.

### Views

#### Item view

A filtered view, based on the `filtered_items` object content is
delivered with data model masks applied. Attributes with
`display = FALSE` will be hidden, and *items* will be ordered as defined
in the data model. It is based on the
[`DT::renderDT()`](https://rdrr.io/pkg/DT/man/dataTableOutput.html) /
[`DT::DTOutput()`](https://rdrr.io/pkg/DT/man/dataTableOutput.html)
functions.

See
[`filtered_view_widget()`](https://thekangaroofactory.github.io/kitems/reference/filtered_view_widget.md)
function.

#### Selected Item(s)

The filtered view has row selection enabled.  
Selecting row(s) in the table will trigger the update of
`selected_items` reactive value entry.  
Selected *item(s)* will also trigger which buttons are available /
visible.

### Inputs

#### Date sliderInput

If the data model has an attribute named ‘*date*’ (literally), a date
[`shiny::sliderInput()`](https://rdrr.io/pkg/shiny/man/sliderInput.html)
will be created automatically to enable date filtering.

See:

- [`date_slider_widget()`](https://thekangaroofactory.github.io/kitems/reference/date_slider_widget.md)
  function to implement it in the UI

- [filtering](https://thekangaroofactory.github.io/kitems/articles/filtering.html#date-slider)
  article

#### Buttons

Standard buttons are delivered to trigger the module server actions.  
They are implemented as separate UI functions so that it’s possible to
wrap them into more complex UI functions.

- create
- update (single item selection)
- delete (supports multi-selection)

Create button is always visible, but update and delete buttons are only
displayed when selected rows fit with above conditions.

See
[`create_widget()`](https://thekangaroofactory.github.io/kitems/reference/create_widget.md),
[`update_widget()`](https://thekangaroofactory.github.io/kitems/reference/update_widget.md)
and
[`delete_widget()`](https://thekangaroofactory.github.io/kitems/reference/delete_widget.md)
functions.

### Dialogs

#### Item Forms

The create & update workflows rely on a form to capture user inputs.  
This form is generated dynamically based on the data model
specifications (attribute type, default values, skip option) so that it
saves a lot of time & code.

See
[`item_form()`](https://thekangaroofactory.github.io/kitems/reference/item_form.md)
function.

## Nested module considerations

By default, the UI / widget functions are called with the `id` that was
defined at the module server function level.

``` r
# -- call module
mydata <- kitems::kitems(id = "mydata", path = "path/to/my/data")

# -- call item view
filtered_view_widget(id = "mydata")
```

But when the module server is implemented as a sub-module (nested module
pattern), it is necessary to follow the namespace tree.

If you don’t want to wrap the widget function output into another UI
function at the main module level, you need to use the namespace
[`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) function:

``` r
# -- call module (as child of a module with id = "module")
mydata <- kitems::kitems(id = "mydata", path = "path/to/my/data")

# -- call item view
filtered_view_widget(id = shiny::NS(namespace = "module", id = "mydata"))
```

This works with any depth – see
[`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) for details about
the `namespace` argument.

## Useful links

- Module server use cases – see
  [implementations](https://thekangaroofactory.github.io/kitems/articles/implementations.md)

- Arguments & return value(s) – see
  [communication](https://thekangaroofactory.github.io/kitems/articles/communication.md)
