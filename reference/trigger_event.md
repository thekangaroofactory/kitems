# Trigger Event

Helper function to create events to be passed to kitems module server
with the `trigger` argument.

## Usage

``` r
trigger_event(
  workflow = c("create", "update", "delete"),
  type = c("dialog", "task"),
  values = NULL
)
```

## Arguments

- workflow:

  the name of the workflow (create, update or delete).

- type:

  the name of the action to be performed (dialog or task).

- values:

  optional list of values to create, update or delete an item.

## Value

A list.

## Details

The function also adds an event id to make it unique (otherwise sending
two times the same request would fail).

For more details see this vignette:
[`vignette("workflows", package = "kitems")`](https://thekangaroofactory.github.io/kitems/articles/workflows.md)

## See also

[`kitems()`](https://thekangaroofactory.github.io/kitems/reference/kitems.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# create dialog event
trigger_event()

# delete item event (without dialog)
trigger_event(workflow = "delete", type = "task", values = list(id = 1234))
} # }
```
