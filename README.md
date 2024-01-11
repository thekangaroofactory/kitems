# Package Specifications

## Purpose

The goal of this package is to create data model management functions.

## Data Model



## Items




## Triggers

Triggers are basically reactiveValues stored in the r object that can be used to communicate actions to the module server.

Their name is built with paste0(id, "_trigger_name"), with [trigger_name] being:
* trigger_add: add an item to the item list
* trigger_update <- update an item from the item list
* trigger_delete <- delete an item from the list
* trigger_save <- save the item list (if autosave is turned off)


## Item creation

It's recommended to use item_create() to create the item to be added to the list:

id <- "my_data"

r_data_model <- dm_name(id)
trigger_add <- trigger_add_name(id)

input_values <- data.frame(id = 1, text = "demo")

item <- item_create(values = input_values, data.model = r[[r_data_model]]())
r[[trigger_add]](item)

Note: if autosave has been turned off, r[[trigger_save]] should be used to make item changes persistent.


## Item update

It's recommended to use item_create() to create a new item to replace the one in the list:

id <- "my_data"

r_data_model <- dm_name(id)
trigger_update <- trigger_update_name(id)

input_values <- data.frame(id = 1, text = "demo update")

item <- item_create(values = input_values, data.model = r[[r_data_model]]())
r[[trigger_update]](item)

