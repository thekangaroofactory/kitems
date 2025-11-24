# Data Model Integrity

Check the data model integrity.

## Usage

``` r
dm_integrity(data.model, items, template = NULL)
```

## Arguments

- data.model:

  a *mandatory* data model.

- items:

  a *mandatory* data.frame of the items.

- template:

  an optional data.frame(name = c(...), type = c(...)) to be used to
  force attribute classes.

## Value

if `data.model` matches with the `items`, `TRUE` will be returned.
Otherwise an updated data model will be returned.

## Details

In case an attribute of the `items` is missing from the `data.model`, it
will be added with either a type matching the template one or a guessed
one (using the [`class()`](https://rdrr.io/r/base/class.html) function).

In case an extra attribute is found in the `data.model` as compared to
the `items`, it will be dropped from the data model.

## Examples

``` r
if (FALSE) { # \dontrun{
feedback <- dm_integrity(mydatamodel, myitems)
if(!is.logical(feedback))
  mydatamodel <- feedback
} # }
```
