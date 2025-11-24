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

  optional values to create, update or delete an item.

## Value

An event object (list).

## Examples

``` r
if (FALSE) { # \dontrun{
# fire create dialog event
trigger_event()
} # }
```
