# Item Modal Dialog(s)

Produces a create / update / delete modal dialog to display.

## Usage

``` r
item_dialog(
  data.model = NULL,
  items = NULL,
  workflow = c("create", "update", "delete"),
  item = NULL,
  shortcut = FALSE,
  ns
)
```

## Arguments

- data.model:

  a data.frame of the data model.

- items:

  a data.frame of the items.

- workflow:

  a character string to indicate workflow (see details).

- item:

  a data.frame of the item to update (when `workflow` = "update").

- shortcut:

  a logical (default `FALSE`) if shortcuts should be activated.

- ns:

  the intended namespace function to use in the dialog.

## Value

a modal dialog to display using
[`shiny::showModal()`](https://rdrr.io/pkg/shiny/man/showModal.html).

## Details

Possible values for workflow are "create", "update" or "delete".
"create" is the default.

## Examples

``` r
if (FALSE) { # \dontrun{
item_dialog(data.model, items, update = FALSE, item = NULL, shortcut = FALSE, ns)
} # }
```
