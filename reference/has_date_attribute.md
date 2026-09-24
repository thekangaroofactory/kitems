# Has Date

Basic check if item has a 'date' attribute.

## Usage

``` r
has_date_attribute(config, item = get_context())
```

## Arguments

- config:

  the config list

- item:

  the name (id) of the item group

## Value

a logical

## Details

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
has_date_attribute(design(project = "test"))
#> Warning: Can't guess the item name (id) from the environment!
#> Warning: Item  does not exist!
#> [1] FALSE
```
