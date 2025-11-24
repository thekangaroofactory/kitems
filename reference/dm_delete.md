# Delete Data Model

Delete Data Model

## Usage

``` r
dm_delete(data.model, items, dm_url, items_url, autosave, item.file)
```

## Arguments

- data.model:

  the reference of the data model reactive value.

- items:

  the reference of the items reactive value.

- dm_url:

  the url (path + filename) of the data model.

- items_url:

  the url (path + filename) of the items.

- autosave:

  a logical if the data should be saved.

- item.file:

  a logical if the item file should be deleted.

## Examples

``` r
if (FALSE) { # \dontrun{
dm_delete(data.model = mydata$data_model,
items = mydata$items,
dm_url,
items_url,
autosave = TRUE,
item.file = TRUE)
} # }
```
