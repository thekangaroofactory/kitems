# Delete Attribute

Delete Attribute

## Usage

``` r
attribute_delete(
  k_data_model,
  k_items,
  name,
  MODULE = NULL,
  autosave = FALSE,
  dm_url = NULL,
  items_url = NULL,
  notify = FALSE
)
```

## Arguments

- k_data_model:

  the reference of the data model reactive value

- k_items:

  the reference of the items reactive value

- name:

  the name of the attribute to delete

- MODULE:

  an optional string to be displayed in the notification

- autosave:

  a logical if autosave is ON

- dm_url:

  the url of the data model file

- items_url:

  the url of the item file

- notify:

  a logical if shiny notification should be fired

## Examples

``` r
if (FALSE) { # \dontrun{
attribute_delete(k_data_model,
k_items,
name = "comment",
MODULE = "mydata",
autosave = TRUE,
dm_url = dm_url,
items_url = items_url,
notify = TRUE)
} # }
```
