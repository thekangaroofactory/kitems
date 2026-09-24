# Get Items

**\[experimental\]**

This function is part of the selective loading mechanism to ensure items
are loaded only when required.

## Usage

``` r
items(datamart, config, item)
```

## Arguments

- datamart:

  a reactiveValues object holding the items.

- config:

  the config list.

- item:

  the name (id) of the item group.

## Value

a data.frame of the items or NULL.

## Examples

``` r
if (FALSE) { # \dontrun{
# init the datamart
datamart <- reactiveValues()

# get items (it will load them)
datamart |> items("foo")

# get them again (already loaded)
datamart |> items("foo")
} # }
```
