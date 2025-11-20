# Update data model attribute

Update data model attribute

## Usage

``` r
attribute_update(
  data.model,
  name,
  default.val = NULL,
  default.fun = NULL,
  default.arg = NULL,
  skip = NULL,
  display = NULL,
  sort.rank = NULL,
  sort.desc = NULL
)
```

## Arguments

- data.model:

  a data.frame containing the data model

- name:

  a character string of the attribute name

- default.val:

  a character string, the new default value

- default.fun:

  a character string, the new default function name

- default.arg:

  an optional named vector of arguments, to pass along with the default
  function.

- skip:

  a logical to set the skip value

- display:

  a logical to set the display value

- sort.rank:

  a numeric, used to define sort rank

- sort.desc:

  a logical, to define if sorting should be in descending order

## Value

the updated data model

## Details

Updating attribute class is not supported by this function (as it
requires data migration).

Use of vector to update several attributes is supported as long as
length of the different parameters is either same as name or 1 (then all
rows gets same value).

## See also

[`data_model()`](https://thekangaroofactory.github.io/kitems/reference/data_model.md)

## Examples

``` r
if (FALSE) { # \dontrun{
#Use of vector to update several attributes:
attribute_update(data.model = dm,
                 name = c("name","total"),
                 default.val = c("test", 2),
                 default.fun = NULL,
                 default.arg = NULL,
                 skip = TRUE)
} # }
```
