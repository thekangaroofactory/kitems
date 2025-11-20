# Module server

Module server

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

  the id to be used for the module server instance

- path:

  a path where data model and items will be stored

- autosave:

  a logical whether the item auto save should be activated or not
  (default = TRUE)

- admin:

  a logical indicating if the admin module server should be launched
  (default = FALSE)

- trigger:

  a reactive object to pass events to the module (see details)

- filter:

  a reactive object to pass filters to the module (see details)

- options:

  a list of options (see details)

## Value

the module server returns a list of the references that are accessible
outside the module. All except id & url are references to reactive
values. list(id, url, items, data_model, filtered_items, selected_items,
clicked_column, filter_date, triggers = list(update))

## Details

If autosave is FALSE, the item_save function should be used to make the
data persistent. To make the data model persistent, use
[saveRDS](https://rdrr.io/r/base/readRDS.html) function. The file name
should be consistent with the output of
[dm_name](https://thekangaroofactory.github.io/kitems/reference/dm_name.md)
function used with `id` plus .rds extension.

When admin is FALSE,
[admin_widget](https://thekangaroofactory.github.io/kitems/reference/admin_widget.md)
will return an 'empty' layout (tabs with no content)
[dynamic_sidebar](https://thekangaroofactory.github.io/kitems/reference/dynamic_sidebar.md)
is not affected by this parameter. It is expected that those function
will not be used when admin = FALSE.

Behavior of the module server can be tuned using a list of options
shortcut option is a logical to activate shortcut mechanism within item
forms

Triggers are the way to send events for the module to execute dedicated
actions. trigger must be a reactive (or NULL, the default). An event is
defined as a named list of the form list(workflow = "create", type =
"dialog") or list(workflow = "create", type = "task", values =
list(...)) If NULL, the trigger manager will not be initialized.

Filter is a reactive object to pass filter expression(s) to the module
server A filter is defined as a named list: list(layer = c("pre",
"main"), expr = ...) If NULL, the filter manager will not be
initialized.

## Examples

``` r
if (FALSE) { # \dontrun{
kitems(id = "mydata", path = "path/to/my/data", autosave = TRUE)
} # }
```
