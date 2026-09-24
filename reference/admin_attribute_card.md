# Attribute Card

This is a UI layout function to display attributes.

## Usage

``` r
admin_attribute_card(attribute, item, hide = NULL, skip = NULL, refresh = NULL)
```

## Arguments

- attribute:

  the yaml of the attribute

- item:

  the name (id) of the item group

- hide:

  the list of attributes to hide

- skip:

  the list of attributes to skip

- refresh:

  the list of attributes to refresh

## Value

A htmltools::div() tag.

## Examples

``` r
if (FALSE) { # \dontrun{
admin_attribute_card(attribute, item)
} # }
```
