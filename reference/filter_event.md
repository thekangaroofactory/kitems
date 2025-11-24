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

An event [`list()`](https://rdrr.io/r/base/list.html).

## Details

When no expression is passed to `...` then the filter layer will be
reset.

## Examples

``` r
if (FALSE) { # \dontrun{
# set pre-filtering layer
filter_event(layer = "pre", expr = name == Banana)

# reset main filter
filter_event(layer = "main")
} # }
```
