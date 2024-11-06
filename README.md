
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- You need to render `README.Rmd` to keep `README.md` up-to-date. -->
<!-- use`devtools::build_readme()` for this.  -->

# kitems

<!-- badges: start -->

[![R-CMD-check](https://github.com/thekangaroofactory/kitems/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/thekangaroofactory/kitems/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/thekangaroofactory/kitems/graph/badge.svg?token=7P74NK51JJ)](https://codecov.io/gh/thekangaroofactory/kitems)

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of kitems is to provide a framework to manage data frame
*items* and a set of tools to implement it within Shiny web
applications.

It is delivered as a Shiny module.

## Installation

The development (*beta*) version of kitems can be installed from
[GitHub](https://github.com/thekangaroofactory/kitems) with:

``` r
# install.packages("devtools")
devtools::install_github("thekangaroofactory/kitems")
```

> Note that the package is under development convergence.  
> Features may still be modified at this stage, and there is no guaranty
> that exported functions signature will not change before it is
> converged.

## Demo

Demo apps are delivered together with the package and can be accessed
with:

``` r
library(kitems)

# -- get example demo name
runExample()
```

## Framework Specifications

The kitems framework is based on two main notions - data model and
*items*.

### Data Model

The data model contains the specifications of the *items* to manage.

For each attribute, the data model carries information like its name and
type, but also a method to determine its default value and logical
values to indicate if it should be skipped in forms, filtered from the
table view or used to sort the data.

Supported types are numeric, integer, logical, character, factor, Date
and POSIXct.

> Note: class POSIXlt is not supported as it stores datetime values into
> a list  
> POSIXct should be used to store datetime attributes.

### Items

*Items* are stored in a data frame that fits with the data model
rules.  
That means the data model is implemented in all functions related to
*item* management.

### Path

Both data model & *item* files are stored in a specific folder dedicated
to that instance of the module.  
The folder is named after the `id` of the module.

For this reason, unless there is a single instance of the module, it is
not recommended to name any of the `id` with same name as the last
folder of the provided path.

Example:

- `path = "./path/to/data" & id = "data"` will store files in
  “./path/to/data”
- `path = "./path/to/data" & id = "data_1"` will store files in
  “./path/to/data/data_1”

It may result in files being stored at different levels.

## Reactive Values

kitems strongly relies on Shiny (both shiny and shinydashboard packages
are set as ‘depends’ dependencies).

It delivers reactive values that are accessible from the module server
return value.

The return value has the following structure:

``` r
list(id,
     url,
     items,
     data_model,
     filtered_items,
     selected_items,
     clicked_column,
     filter_date)
```

> Data model and *items* reactive values should be handled with caution
> as updating there values will trigger auto save (if
> `autosave = TRUE`).

### Data Model

The data model can be accessed **in a reactive context** from the return
value list, as data_model()

``` r
library(kitems)

# -- call module
mydata <- kitems_server(id = "my_data_id", path = "path/to/my/data")

# -- get data model
data_model <- mydata$data_model()
```

### Items

The items for this id can be accessed **in a reactive context** from the
return value list, as items()

``` r
# -- call module
mydata <- kitems_server(id = "my_data_id", path = "path/to/my/data")

# -- get items
items <- mydata$items()
```

### Observe reactive values

The module server return value holds references to the reactives
values.  
Here is an example how to observe the *items*:

``` r
# -- Call module server
mydata <- kitems(id = "mydata", path = "./data")

# -- Observe items
observeEvent(mydata$items(), {
  cat("Main application server: items object has just been updated. \n")
  # -- do something cool here
  })
```

> Note: when observing the `filtered_items` from the main application,
> it’s recommended to add the `ignoreInit = TRUE` parameter (or use
> `bindEvent` for render\* functions) in order to avoid multiple
> computations at start-up.

## Data model

### Initialization

When starting the module with id and path arguments, it will check if
the corresponding data model is available in the destination path.

If no data model is found, the admin UI will display a button to create
a new data model, as well as a button to import data (it creates the
data model from the data).

### Checking integrity

When the module server is launched, it will perform an integrity check
to ensure that the *items* and data model are synchronized.

If not, the data model will be updated to match with any missing
attribute for example.  
Items will be checked as well to make sure attribute types fit with the
data model.

## Item management

The *create* and *update* buttons triggers a dynamic form that is built
based on the data model.  
Attributes defined as *skipped* won’t get an input in the form.  
The inputs are initialized with the default values or output of the
default functions when defined.  
After the form is completed, a check is performed to make sure values
match the attribute types.  
If no value is provided for an attribute, the default is applied.

## Views

### Filtered view

A filtered view, based on the filtered_items content is delivered with
data model masks applied.  
Filtered attributes will be hidden, and *items* will be ordered as
defined in the data model.

## Selected Item(s)

The filtered view have row selection enabled.  
Selecting row(s) in the table will trigger the update of selected_items
reactive value.  
Selected *item(s)* will also trigger which buttons are available (delete
is not visible if no item is selected).

## Inputs

### Date sliderInput

If the data model has an attribute named ‘*date*’, a date sliderInput
will be created automatically to enable date filtering. If not
implemented in the main application UI, it will have no impact on the
filtered *items*.

### Buttons

Standard buttons are delivered to trigger the module server actions.  
They are implemented as separate UI functions so that it’s possible to
wrap them into a more complex UI function.

- create
- update (single item selection)
- delete (supports multi-selection)

## Administration

### Admin console

An admin console is delivered as a standalone Shiny app.  
The reason is that in most cases, it’s not recommended to have the data
model(s) management accessible from within the application.

The admin console gives access to all the data models belonging to the
`path` argument in one place.

## Nested module considerations

In case the kitems module server function is called from inside a module
(i.e. as a nested module), then it is not possible to call the UI
functions from the main app with the nested module `id`.

From there, two options are available:

- wrap the package UI functions into functions from the calling module
  (encapsulation)  
  For example, create a UI function that implements the different
  buttons into a single UI delivered by the calling module.

- call the package UI functions directly from the main app using
  multiple namespaces:  
  (as specified in the `shiny::NS` function)

``` r
 kitems::admin_widget(c("module_id", "nested_module_id"))
```
