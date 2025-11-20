# Build Item Form

Build Item Form

## Usage

``` r
item_form(data.model, items, update = FALSE, item = NULL, shortcut = FALSE, ns)
```

## Arguments

- data.model:

  the data.frame of the data model

- items:

  the data.frame of the items

- update:

  an optional logical (default = FALSE) to trigger update behavior

- item:

  an optional item (used to set default input values if update = TRUE)

- shortcut:

  a logical to indicate if shortcuts should be displayed

- ns:

  the namespace function, output of shiny::NS()

## Value

a tagList() object containing the attribute inputs

## Details

Data model skip feature will be used to return inputs only for the skip
= FALSE attributes

## Examples

``` r
if (FALSE) { # \dontrun{
item_form(data.model = mydata$data_model(), update = FALSE, item = NULL, ns)
item_form(data.model = mydata$data_model(), update = TRUE, item = myitem, ns)
} # }
```
