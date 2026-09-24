# Prepare Values

Turn trigger values into tabular data.

## Usage

``` r
prepare(values, config, update = FALSE, item = get_context())
```

## Arguments

- values:

  a named list of values (see details).

- config:

  the config list.

- update:

  a logical if values are used in the update workflow (default `FALSE`).

- item:

  optional (see details), the name (id) of the item group.

## Value

a data.frame

## Details

`values` is a named list. The names are used to check the corresponding
values vs the data.model (class, default values if the provided ones are
not valid). The elements in the list must have either length one or same
length as the id element.

When an element has length one but the id has several values, all items
corresponding to these ids will be updated with same value. To do so,
values will be turned into a data.frame using as.data.frame ; for this
reason, it's strongly advised to wrap the call into
[`tryCatch()`](https://rdrr.io/r/base/conditions.html) as this may fail.

When `item` is set in the parent frame, then the attribute can be
skipped in the function call.

## See also

[`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)

## Examples

``` r
if (FALSE) { # \dontrun{
prepare(values, config, item = "foo")
} # }
```
