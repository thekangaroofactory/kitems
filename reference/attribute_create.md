# Add attribute to a data model

Add attribute to a data model

## Usage

``` r
attribute_create(
  data.model,
  name,
  type,
  default.val = NULL,
  default.fun = NULL,
  default.arg = NULL,
  display = NULL,
  skip = NULL,
  sort.rank = NULL,
  sort.desc = NULL
)
```

## Arguments

- data.model:

  a *mandatory* data model, structured as an output of data_model()
  function

- name:

  a *mandatory* character string for the new attribute name

- type:

  a *mandatory* character string for the new attribute type

- default.val:

  an optional named vector of values, defining the default values.

- default.fun:

  an optional named vector of functions, defining the default functions
  to be used to generate default values.

- default.arg:

  an optional named vector of arguments, to pass along with the default
  function.

- display:

  an optional character vector, with the name(s) of the attribute(s) to
  display

- skip:

  an optional character vector, with the name(s) of the attribute(s) to
  skip

- sort.rank:

  an optional named numeric vector, to define sort orders

- sort.desc:

  an optional named logical vector, to define if sort should be
  descending

## Value

the updated data model

## See also

[`data_model()`](https://thekangaroofactory.github.io/kitems/reference/data_model.md)

## Examples

``` r
if (FALSE) { # \dontrun{
attribute_create(data.model = mydatamodel, name = "new_attribute", type = "character")
attribute_create(data.model = mydatamodel, name = "total", type = "numeric", default.val = 0)
attribute_create(data.model = mydatamodel, name = "date", type = "Date", default.fun = "Sys.Date")
attribute_create(data.model = mydatamodel, name = "progress", type = "integer", skip = "progress")
attribute_create(data.model = mydatamodel, name = "internal",
type = "logical", display = "internal")
} # }
```
