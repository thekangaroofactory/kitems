
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- You need to render `README.Rmd` to keep `README.md` up-to-date. -->
<!-- use`devtools::build_readme()` for this.  -->

# kitems

<!-- badges: start -->
<!-- badges: end -->

The goal of kitems is to provide a framework to manage data.frame like
items and a set of tools to implement it within a shiny web application.
For that reason, it is delivered as a shiny module.

## Code coverage

[![codecov](https://codecov.io/gh/thekangaroofactory/kitems/graph/badge.svg?token=7P74NK51JJ)](https://codecov.io/gh/thekangaroofactory/kitems)

## Installation

You can install the development version of kitems from
[GitHub](https://github.com/thekangaroofactory/kitems) with:

``` r
# install.packages("devtools")
devtools::install_github("thekangaroofactory/kitems")
```

## Demo

A basic shiny demo app which shows you how to use the package is
delivered and can be run:

## Framework Specifications

The kitems framework is based on two main notions: data model and items.

### Data Model

The data model contains the specifications of the items you want to
manage. It includes:

- name
- type
- default value
- default function
- filter
- skip

Supported types are:

- numeric
- integer
- logical
- character
- factor
- Date
- POSIXct
- POSIXlt

Defaults (value and function) are used to setup a value if it’s not
provided during the item creation process. For function, the reference
of the function should be passed (as a callback), for example “Sys.Date”

Filter is a logical to indicate if the attribute should be filtered from
the item views (for example id) Skip is a logical to indicate if the
attribute should be skipped to build the input form (thus will get
default value)

### Items

Items is a data.frame containing the data to be managed.

## Reactive Values

kitems strongly relies on Shiny (shiny and shinydashboard packages are
set as ‘depends’ dependencies). It provides reactive values (accessible
from the module server return value):

- data_model (reactiveVal)
- items (reactiveVal)
- filtered_items (reactiveVal)
- selected_items (reactiveVal)
- clicked_column (reactiveVal)
- filter_date (reactiveVal)

The module server return value has the following structure:

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

> \[!CAUTION\] Data model and items reactive values should be handled
> with caution as updating there values will trigger auto save (for
> items, if autosave = TRUE).

### Data Model

``` r
library(kitems)

# -- call module
mydata <- kitemsManager_Server(id = "my_data_id", path = "path/to/my/data", create = TRUE, autosave = TRUE)

# -- get data model
data_model <- mydata$data_model()
```

The data model can be accessed **in a reactive context** from the return
value list, as data_model()

### Items

``` r

# -- call module
mydata <- kitemsManager_Server(id = "my_data_id", path = "path/to/my/data", create = TRUE, autosave = TRUE)

# -- get items
items <- mydata$items()
```

The items for this id can be accessed **in a reactive context** from the
return value list, as items()

## Data model

### Initialization

When starting the module with id and path arguments, it will check if
the corresponding data model is available (if the file exists).

If no data model is found, the admin UI will display a create button to
start a new data model, as well as an import data button.

### Checking integrity

When the module server is launched, it will perform an integrity check
to ensure that the data (items) and data model are aligned.

This is done through the dm_check_integrity() function. If not aligned,
the data model will be updated to match with any missing attribute for
example.

## Item management

### Item creation

It’s recommended to use item_create() function to create an item to be
added to the item list:

``` r
library(kitems)

# -- call module
mydata <- kitemsManager_Server(id = "my_data_id", path = "path/to/my/data", create = TRUE, autosave = TRUE)

# -- define inputs and create item (waning! this should be used in a reactive context)
input_values <- data.frame(id = 1, text = "demo")
item <- item_create(values = input_values, data.model = mydata$data_model())

# -- add item (waning! this should be used in a reactive context)
item_add(items = mydata$items, item)
```

Note: if autosave has been turned off, item_save function should be used
to make item changes persistent.

### Item update

It’s recommended to use item_create() function to create a new item and
replace the one in the item list:

``` r
library(kitems)

# -- call module
mydata <- kitemsManager_Server(id = "my_data_id", path = "path/to/my/data", create = TRUE, autosave = TRUE)

# -- define inputs and create item (waning! this should be used in a reactive context)
input_values <- data.frame(id = 1, text = "demo")
item <- item_create(values = input_values, data.model = mydata$data_model())

# -- update item (waning! this should be used in a reactive context)
item_update(items = mydata$items, item)
```

### Item delete

To delete an item, just pass it’s id to the trigger:

``` r
library(kitems)

# -- call module
mydata <- kitemsManager_Server(id = "my_data_id", path = "path/to/my/data", create = TRUE, autosave = TRUE)

# -- delete item (waning! this should be used in a reactive context)
item_id <- 1704961867683 
item_delete(mydata$items, id)
```

## Views

### Default view

The default view is provided through items_view_DT(). It is based on the
items content (with data model masks applied).

### Filtered view

The filtered view is provided through items_filtered_view_DT() It is
based on the filtered_items content (with data model masks applied).

## Selected Item(s)

Both default and filtered view have row selection enabled. Selecting
row(s) in *one or the other* table will trigger the update of
selected_items reactive value.

> \[!CAUTION\] It is not recommended to display both views in the same
> UI section as only the last selection will be kept in selected_items

Selected item(s) will also trigger which buttons are available (or
NULL).

## Inputs

### Date sliderInput

If the data model has an attribute named ‘date’, a date sliderInput will
be created automatically to enable date filtering.

This sliderInput will trigger a filter on the items to be displayed in
the filtered view, i.e. only the matching items will be part of this
view.

If not implemented through date_slider_INPUT() in your application’s UI,
then no date filter is applied by default on the filtered view.

Filter value (the sliderInput range) is available in the filter_date
reactive value.

**Note** In case you want to build a reactive object on top of
filter_date and filtered_items, it is recommended to test both for NULL
to avoid firing computation at startup.

### Buttons

- create_BTN: create item
- update_BTN: update selected item (single selection)
- delete_BTN: delete selected item(s) (supports multi-selection)

update_BTN and delete_BTN return NULL if no row is selected.

## UI objects

### Admin UI

In order to avoid code duplication, an admin UI interface is provided by
the admin_ui() function.

``` r

# -- Inside tabItems
tabItems(...,

         tabItem(tabName = "mydata",
                 
                 # -- Admin UI
                 fluidRow(
                   column(width = 12,
                          
                          kitems::admin_ui("mydata"))))
)
```

### Sidebar

A sidebarMenu object (menuItem) is also available as an output of the
dynamic_sidebar() function. It will contain one menuSubItem object per
data model (stored in the r reactive values).

To implement it in your sidebar UI, it must first be rendered in your
application server code:

``` r
# -------------------------------------
# Generate dynamic sidebar
# -------------------------------------

output$menu <- renderMenu(dynamic_sidebar(names = list("data", "data2")))
```

Then you can use this output inside the application UI code:

``` r
# -------------------------------------
# Define Sidebar UI
# -------------------------------------

sidebar <- dashboardSidebar(

  # -- static section
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("dashboard"), selected = TRUE)),

  # -- add dynamic section
  sidebarMenu(id = "tabs", sidebarMenuOutput("menu")),

  collapsed = FALSE)
```

The tabName linked to each menuSubItem should be named after the module
id. Here is an example how to access the administration console from the
menuSubItem:

``` r
# -- kitems admin
tabItem(tabName = "my_data",
        
        # -- Admin UI
        fluidRow(
          column(width = 12,
                 
                 kitems::admin_ui("my_data"))))
```

### Nested module considerations

In case the kitemsManager_Server module server function is called from
inside a module (i.e. as a nested module), then it is not possible to
call the UI functions from the main app with the nested module id.

From there, two options are available:

- wrap the package UI functions into functions from the calling module
  (encapsulation)  
  For example, you could create an action_BTN function that would
  implement create_BTN, update_BTN and delete_BTN into a single UI

- call the package UI functions directly from the main app using
  multiple namespaces:  
  (as specified in the shiny::NS function)

``` r
 kitems::admin_ui(c("module_id", "nested_module_id"))
```

## Import & migration

When the module server is initialized with data.model = NULL, an import
data button is displayed in the data model section of the admin UI. This
allows to create a data model from existing data.

## Reactivity

### Observe items

``` r
# -------------------------------------
# Observe item lists
# -------------------------------------

id <- "mydata"
mydata <- items_name(id)

# -- Module id = mydata
observeEvent(mydata$items(), {
  
  cat("Main application server observer: items object has just been updated. \n")
  
})
```
