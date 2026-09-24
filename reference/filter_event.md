# Filter Event

Helper function to create filter events to be passed to kitems module
server with the filter argument.

## Usage

``` r
filter_event(layer = c("pre", "main"), ...)
```

## Arguments

- layer:

  the filter layer ("pre" or "main").

- ...:

  the expression(s) to pass to the filter.

## Value

A list.

## Details

When no expression is passed to `...` then the filter layer will be
reset.

See the module server function to know how to pass the event to the
module server.

For more details see this vignette:
[`vignette("filtering", package = "kitems")`](https://thekangaroofactory.github.io/kitems/articles/filtering.md)

## See also

[`kitems()`](https://thekangaroofactory.github.io/kitems/reference/kitems.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# set pre-filtering layer
filter_event(layer = "pre", expr = name == Banana)

# reset main filter
filter_event(layer = "main")
} # }
```
