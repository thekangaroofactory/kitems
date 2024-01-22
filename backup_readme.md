# Package Specifications

## Purpose

The goal of this package is to create data model management functions.

## Data Model



## Items



--------------------------------------------------------------------------------

## Reactive Values (accessible from r object)

- r[[r_data_model]]
- r[[r_items]]

- r[[trigger_add]]
- r[[trigger_update]]
- r[[trigger_delete]]
- r[[trigger_save]]


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


## Item delete

To delete an item, just pass it's id to the trigger:

id <- "my_data"

trigger_delete <- trigger_delete_name(id)

item_id <- 1704961867683
r[[trigger_delete]](item_id)


--------------------------------------------------------------------------------
## Inputs

### date_slider_INPUT

If the data model has an attribute named 'date', a date sliderInput will be created automatically
to enable date filtering.

This sliderInput will trigger a filter on the items to be displayed in the filtered view.

If not implemented in your application's UI, then no date filtered is applied by default.

### Buttons

create item
update item : single selection
delete item : support multi selection
