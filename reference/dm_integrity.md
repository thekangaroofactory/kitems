# Check data model integrity

Check data model integrity

## Usage

``` r
dm_integrity(data.model, items, template = NULL)
```

## Arguments

- data.model:

  a *mandatory* data model

- items:

  a *mandatory* item data.frame

- template:

  an optional data.frame(name = c(...), type = c(...)) to be used to
  force attribute classes

## Value

if data model matches with the data, TRUE will be returned. Otherwise an
updated data model will be returned.

## Details

In case an attribute is missing from the data model, it will be added
with either a type matching the template one or a guessed one (using the
class() function).

In case an extra attribute is found in the data model as compared to the
items, it will be dropped from the data model.

## Examples

``` r
if (FALSE) { # \dontrun{
feedback <- dm_integrity(mydatamodel, myitems)
if(!is.logical(feedback))
  mydatamodel <- feedback
} # }
```
