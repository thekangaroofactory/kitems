# Update Attribute Input

Update Attribute Input

## Usage

``` r
attribute_input_update(data.model, shortcut_trigger, MODULE = NULL)
```

## Arguments

- data.model:

  a data.frame of the data model

- shortcut_trigger:

  basically the value of input\$shortcut_trigger

- MODULE:

  an optional character string for the trace

## Examples

``` r
if (FALSE) { # \dontrun{
attribute_input_update(
data.model = mydata$data_model,
shortcut_trigger = "name_banana",
MODULE = "(mydata)")
} # }
```
