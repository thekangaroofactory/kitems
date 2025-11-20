# Data model delete preview modal

Data model delete preview modal

## Usage

``` r
dm_delete_preview(
  hasItems = FALSE,
  dm.file = FALSE,
  item.file = FALSE,
  autosave = FALSE,
  id = NULL,
  ns
)
```

## Arguments

- hasItems:

  a logical if there are items (items data frame not NULL)

- dm.file:

  a logical if data model file exists

- item.file:

  a logical if item file exists

- autosave:

  a logical if autosave is ON

- id:

  the id if the module

- ns:

  the namespace function to be used

## Value

a modalDialog

## Examples

``` r
if (FALSE) { # \dontrun{
dm_delete_preview(hasItems = TRUE,
dm.file = TRUE,
item.file = TRUE,
autosave = TRUE,
id = "mydata",
ns = ns)
} # }
```
