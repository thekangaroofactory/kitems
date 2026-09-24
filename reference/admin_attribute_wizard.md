# Attribute Wizard

The function launches a modal window to display a step by step attribute
wizard.

## Usage

``` r
admin_attribute_wizard(
  config,
  item,
  attribute = NULL,
  callback,
  session = getDefaultReactiveDomain()
)
```

## Arguments

- config:

  the YAML config

- item:

  the name (id) of the item group

- attribute:

  an optional name to indicate it's an update

- callback:

  a reactiveVal to send the output of the wizard

- session:

  optional, the Shiny session object

## Examples

``` r
if (FALSE) { # \dontrun{
admin_attribute_wizard(config, item = "foo")
} # }
```
