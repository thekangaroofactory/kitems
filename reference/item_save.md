# Save Items

Saves the items data.frame.

## Usage

``` r
item_save(data, connector)
```

## Arguments

- data:

  a data.frame containing the data to be saved.

- connector:

  a list that will be passed to
  [`iker::save_data()`](https://thekangaroofactory.github.io/iker/reference/save_data.html)
  function.

## Examples

``` r
if (FALSE) { # \dontrun{
# -- File connector:
item_save(data = mydata, connector = list(type = "file", file = "path/to/my/data/mydata.csv"))
} # }
```
