# Update Attribute

Update a data model attribute

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

  a named vector of arguments, to pass along with the default function.

- skip:

  a logical to set the skip value

- display:

  a logical to set the display value

- sort.rank:

  a numeric, used to define sort rank

- sort.desc:

  a logical, to define if sorting should be in descending order

## Value

The updated data model data.frame

## Details

Updating attribute class is not supported by this function (as it
requires data migration).

The use of vectors to update several attributes is supported as long as
the [`length()`](https://rdrr.io/r/base/length.html) of the different
parameters is either same as `name` or 1 (then all rows gets same
value).

## See also

[`data_model()`](https://thekangaroofactory.github.io/kitems/reference/data_model.md)

## Examples

``` r
# -- define dm
dm <- data_model(colClasses = c(name = "character", total = "numeric"))

# -- Use of vectors to update several attributes
attribute_update(data.model = dm,
                 name = c("name","total"),
                 default.val = c("test", 2),
                 skip = TRUE)
#>    name      type default.val default.fun default.arg display skip sort.rank
#> 1  name character        test          NA          NA   FALSE TRUE        NA
#> 2 total   numeric           2          NA          NA   FALSE TRUE        NA
#>   sort.desc
#> 1        NA
#> 2        NA
```
