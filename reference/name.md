# Kitems Names

Helper function to homogenize names across the package.

## Usage

``` r
name(
  id = NULL,
  what = c("item", "dm", "config"),
  file = FALSE,
  url = FALSE,
  backup = FALSE
)
```

## Arguments

- id:

  the name (id) of the item group.

- what:

  the targeted object (item, dm or config).

- file:

  a logical if file extension should be added.

- url:

  a logical if the url should be returned.

- backup:

  a logical if a timestamp should be added.

## Value

a character string.

## Details

`what` accepts "dm" for backward compatibility reasons (backup & restore
old data.model files before migration to YAML config).

When `url` is `TRUE`, then `file` is considered `TRUE` as well. When
`backup` is `TRUE`, then `file` is considered `TRUE` as well.

Note that from v0.8.0 url for the config is build from the
`R_KITEMS_PATH` environment variable and url for the item groups is
contained in the YAML config.

## Examples

``` r
# item name
name("foo")
#> [1] "foo_items"
```
