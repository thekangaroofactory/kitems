# Create Event

Helper function to create events to be passed to kitems module server
with the trigger argument.

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

  the name of the workflow

- type:

  the name of the action to be performed

- values:

  optional values to create, update or delete an item

## Value

a event (list)

## Examples

``` r
if (FALSE) { # \dontrun{
# fire create dialog event
trigger_event()
} # }
```
