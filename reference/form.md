# Item Form

Builds the create or update item form.

## Usage

``` r
form(attributes, items = NULL)
```

## Arguments

- attributes:

  a data.frame of the attributes (see details).

- items:

  an optional data.frame of the items (see details).

## Value

A list of HTML tags.

## Details

`attributes` is expected to be the output of the
[`default()`](https://thekangaroofactory.github.io/kitems/reference/default.md)
or
[`as_default()`](https://thekangaroofactory.github.io/kitems/reference/as_default.md)
function. The data.frame should have the following columns: "name",
"type", "default", "values".

`items` are required only when the attribute values defined in the
data.model should be evaluated with data masking support.

## Examples

``` r
if (FALSE) { # \dontrun{
form(attributes = data.frame(name = "total", type = "numeric"))
} # }
```
