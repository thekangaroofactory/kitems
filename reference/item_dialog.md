# Item Modal Dialog

Item Modal Dialog

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

  a data.frame of the data model

- items:

  a data.frame of the items

- workflow:

  a character string to indicate workflow (see details)

- item:

  a data.frame of the item to update (when update = TRUE)

- shortcut:

  a logical (default FALSE) if shortcuts should be activated

- ns:

  the intented namespace function to use in the dialog

## Value

a modal dialog

## Details

Possible values for workflow are c("create", "update", "delete")
"create" is the default

## Examples

``` r
if (FALSE) { # \dontrun{
item_dialog(data.model, items, update = FALSE, item = NULL, shortcut = FALSE, ns)
} # }
```
