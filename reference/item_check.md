# Check Items

Check Items

## Usage

``` r
item_check(items, config, id)
```

## Arguments

- items:

  the data.frame of the items

- config:

  the YAML config list

- id:

  the name of the item

## Value

a list

## Details

It is expected that config is checked first using
[`config_check()`](https://thekangaroofactory.github.io/kitems/reference/config_check.md).

## Examples

``` r
if (FALSE) { # \dontrun{
item_check(items, config, "foo")
} # }
```
