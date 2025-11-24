# Kitems Module Server

This is the main component of the package.

## Usage

``` r
kitems(
  id,
  path,
  autosave = TRUE,
  admin = FALSE,
  trigger = NULL,
  filter = NULL,
  options = list(shortcut = FALSE)
)
```

## Arguments

- id:

  the id to be used for the module server instance.

- path:

  a path where data model and items are stored.

- autosave:

  a logical whether the item auto save should be activated or not
  (default = `TRUE`).

- admin:

  a logical indicating if the admin module server should be launched
  (default = `FALSE`).

- trigger:

  a reactive object to pass workflow events to the module (see details).

- filter:

  a reactive object to pass filters to the module (see details).

- options:

  a list of options (see details).

## Value

the module server function returns a list of the reactive references
that are accessible outside the module. All elements except `id` & `url`
are references to reactive values.

- id = the `id` of the module (same as the input argument)

- url = the url of the items

- items = the reference of the items reactive

- data_model = the reference of the data model reactive

- filtered_items = the reference of the filtered items reactive

- selected_items = the reference of the selected items (ids)

- clicked_column = the reference of the clicked column reactive

- filters = the reference of the reactive list with filter expressions.

## Details

If autosave is `FALSE`, the
[`item_save()`](https://thekangaroofactory.github.io/kitems/reference/item_save.md)
function should be used to make the data persistent. To make the data
model persistent, use [saveRDS](https://rdrr.io/r/base/readRDS.html)
function. The file name should be consistent with the output of
[dm_name](https://thekangaroofactory.github.io/kitems/reference/dm_name.md)
function used with `id` plus .rds extension.

When admin is `FALSE`,
[admin_widget](https://thekangaroofactory.github.io/kitems/reference/admin_widget.md)
will return an 'empty' layout (tabs with no content) It is expected that
this function will not be used when admin = `FALSE`.

Behavior of the module server can be tuned using a list of options:

- `shortcut` option is a logical to activate shortcut mechanism within
  item forms.

Triggers are the way to send events for the module to execute dedicated
actions. `trigger` must be a reactive (or `NULL`, the default). An event
is defined as a named list of the form
`list(workflow = "create", type = "dialog")` or
`list(workflow = "create", type = "task", values = list(...))` If
`NULL`, the trigger manager will not be initialized.

`filter` is a reactive object reference to pass filter expression(s) to
the module server A filter is defined as a named list:
`list(layer = c("pre", "main"), expr = ...)`. If `NULL`, the filter
manager will not be initialized.

## Examples

``` r
if (FALSE) { # \dontrun{
kitems(id = "mydata", path = "path/to/my/data", autosave = TRUE)
} # }
```
