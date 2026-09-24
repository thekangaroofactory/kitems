# Read YAML config file

Read YAML config file

## Usage

``` r
config_read(path = Sys.getenv("R_KITEMS_PATH"))
```

## Arguments

- path:

  where to find \_kitems.yml

## Value

a list or NULL if no file is found.

## Details

By default, `path` uses the R_KITEMS_PATH environment variable.

## Examples

``` r
if (FALSE) { # \dontrun{
config_read()
} # }
```
