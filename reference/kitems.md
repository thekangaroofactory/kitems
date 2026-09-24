# Kitems Module Server

This is the main component of the package.

## Usage

``` r
kitems(
  id,
  path = Sys.getenv("R_KITEMS_PATH"),
  trigger = NULL,
  filter = NULL,
  options = list(autosave = TRUE, notify = TRUE)
)
```

## Arguments

- id:

  the unique id of the module server instance.

- path:

  where the YALM config and items are stored (see details).

- trigger:

  an optional reactive object to pass workflow events (see details).

- filter:

  an optional reactive object to pass filter events (see details).

- options:

  an optional list of options (see details).

## Value

a list

Details about the elements of this list:

- id = the `id` of the module (same as the input)

- items = the reference of the items reactive object

- data_model = a list, describing the item's data model

- filtered_items = the reference of the filtered items reactive object

- selected_items = the reference of the selected items (ids) reactive
  object

- clicked_column = the reference of the clicked column reactive object

- filters = the reference of the reactive list with filter expressions.

## Details

Since version 0.8.0, the recommended way to define the `path` argument
is to set the `R_KITEMS_PATH` environment variable. If directly passed
as an argument value, a warning will be raised at the console.

Behavior of the module server can be tuned using a list of options:

- `autosave` is a logical whether the item auto save should be activated
  or not (default = `TRUE`)

- `notify` is a logical if Shiny notifications should be displayed
  (default = `TRUE`) Partial lists are supported, with missing elements
  getting the default value.

If autosave option is `FALSE`, the
[`item_save()`](https://thekangaroofactory.github.io/kitems/reference/item_save.md)
function should be used to make the data persistent.

Triggers are the way to send events for the module to execute dedicated
actions. `trigger` must be a reactive (or `NULL`, the default). An event
is defined as a named list (see examples) and may be created using the
[`trigger_event()`](https://thekangaroofactory.github.io/kitems/reference/trigger_event.md)
function. If `NULL`, the trigger manager will not be initialized.

`filter` is a reactive object reference to pass filter expression(s) to
the module server A filter is defined as a named list (see examples). It
may be created using the
[`filter_event()`](https://thekangaroofactory.github.io/kitems/reference/filter_event.md)
helper function. If `NULL`, the filter manager will not be initialized.

## See also

[`trigger_event()`](https://thekangaroofactory.github.io/kitems/reference/trigger_event.md),
[`filter_event()`](https://thekangaroofactory.github.io/kitems/reference/filter_event.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# baseline:
# launch module server to handle item group named "foo"
kitems(id = "foo")

# read only:
kitems(id = "foo", options = list(autosave = FALSE))

# trigger:
# pass workflow events to the module server
trigger <- reactiveVal()
kitems(id = "foo", trigger = trigger)

# fire the create item dialog:
trigger(list(workflow = "create", type = "dialog"))

# fire an item creation (no dialog):
# assuming 'foo' item has a 'name' character attribute
trigger(list(workflow = "create", type = "task", values = list(name = "test")))

# filter:
# pass filter events to the module server
filter <- reactiveVal()
kitems(id = "foo", filter = filter)

# apply filter at the pre-filtering layer
# assuming item 'foo' has a 'total' numeric attribute
filter(list(layer = "pre", expr = total > 10))
} # }
```
