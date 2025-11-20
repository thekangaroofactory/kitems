# Add attribute to existing items

Add attribute to existing items

## Usage

``` r
item_migrate(items, name, type, fill = NA)
```

## Arguments

- items:

  a data.frame of the items

- name:

  a character string of the attribute name

- type:

  a character string of the attribute type

- fill:

  the value (default = NA) to be used to fill the existing rows (see
  details)

## Value

the updated items data.frame

## Details

fill will be coerced to the class name provided in type If a vector is
given as input for fill, it will be used:
items[name](https://rdrr.io/r/base/name.html) \<- value Make sure the
vector length is same as the number of rows, otherwise an error will be
raised by R

## Examples

``` r
if (FALSE) { # \dontrun{
item_migrate(items = myitems, name = "comment", type = "character", fill = "none")
} # }
```
