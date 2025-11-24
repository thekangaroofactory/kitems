# kitems Admin Module Server

The admin module server is the back end of the admin console app.

## Usage

``` r
kitems_admin(k_data_model, k_items, path, dm_url, items_url, autosave)
```

## Arguments

- k_data_model:

  the reference of the data model reactive value.

- k_items:

  the reference of the item reactive value.

- path:

  the path provided to the kitems server.

- dm_url:

  the url of the data model file.

- items_url:

  the url of the item file.

- autosave:

  the autosave value passed to the kitems server.

## Examples

``` r
if (FALSE) { # \dontrun{
kitems_admin(
k_data_model = mydata$data_model,
k_items = mydata$items,
path = path,
dm_url = dm_url,
items_url = items_url,
autosave = autosave)
} # }
```
