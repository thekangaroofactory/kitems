# Load Items

Load Items

## Usage

``` r
item_load(col.classes, file = NULL, path = NULL)
```

## Arguments

- col.classes:

  a named vector containing the expected column types.

- file:

  an optional file name (including .csv extension).

- path:

  an optional path to the file.

## Value

The data.frame of the items.

## Details

File connector: if file is not `NULL`, then data are loaded from the
given .csv file.

## Examples

``` r
if (FALSE) { # \dontrun{
# -- File connector:
item_load(col.classes = c(id = "numeric", date = "Date", comment = "character"),
file = "mydata.csv", path = "path/to/my/data")
} # }
```
