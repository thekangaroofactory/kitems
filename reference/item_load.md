# Load Items

Load Items

## Usage

``` r
item_load(connector, col.classes)
```

## Arguments

- connector:

  a list that will be passed to
  [`iker::load_data()`](https://rdrr.io/pkg/iker/man/load_data.html)
  function.

- col.classes:

  a named vector containing the expected column types.

## Value

The data.frame of the items.

## Examples

``` r
if (FALSE) { # \dontrun{
# -- File connector:
item_load(col.classes = c(id = "numeric", date = "Date", comment = "character"),
connector = list(type = "file", path = "path/to/my/data", filename = "mydata.csv"))
} # }
```
