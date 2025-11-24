# Save Items

Saves the items data.frame.

## Usage

``` r
item_save(data, file = NULL)
```

## Arguments

- data:

  a data.frame containing the data to be saved.

- file:

  the url of the file (including path & .csv extension).

## Details

File connector: if file is not `NULL`, then data is saved to .csv

## Examples

``` r
if (FALSE) { # \dontrun{
# -- File connector:
item_save(data = mydata, file = "path/to/my/data/mydata.csv")
} # }
```
