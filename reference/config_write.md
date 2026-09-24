# Write YAML config file

Write YAML config file

## Usage

``` r
config_write(x, path = Sys.getenv("R_KITEMS_PATH"))
```

## Arguments

- x:

  a list object to write to YAML

- path:

  where to store the \_kitems YAML file

## Details

By default, `path` uses the R_KITEMS_PATH environment variable.

## Examples

``` r
if (FALSE) { # \dontrun{
config_write(list(foo = 1, bar = "two"))
} # }
```
