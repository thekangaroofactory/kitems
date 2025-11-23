# Add Attribute

Add an attribute to a data model

## Usage

``` r
attribute_create(
  data.model = NULL,
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

  a data model data.frame, structured as an output of the
  [`data_model()`](https://thekangaroofactory.github.io/kitems/reference/data_model.md)
  function

- name:

  a character vector for the new attribute name

- type:

  a character vector for the new attribute type

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

The updated data model data.frame

## Details

Multiple attribute creation is supported, in this case make sure all
vectors have same length.

When `data.model` is omitted, the function will return a data model
containing the created attributes.

## See also

[`data_model()`](https://thekangaroofactory.github.io/kitems/reference/data_model.md)

## Examples

``` r
if (FALSE) { # \dontrun{

# -- create single attribute
attribute_create(name = "new_attribute", type = "character")
attribute_create(name = "total", type = "numeric", default.val = 0)
attribute_create(name = "date", type = "Date", default.fun = "Sys.Date")
attribute_create(name = "progress", type = "integer", skip = "progress")
attribute_create(name = "internal", type = "logical", display = "internal")

# -- create multiple attributes


} # }
```
