# Default Value(s)

Compute the default value(s).

## Usage

``` r
dm_default(data.model, name, n = 1)
```

## Arguments

- data.model:

  a data.frame containing the data model.

- name:

  a character string with the attribute name.

- n:

  an integer (default 1) to use when a vector is expected for default
  function case.

## Value

A vector of length `n`.

## Details

Whenever a default function is set for an attribute of the data.model,
it is possible to generate a vector of default values instead of a
single default value by using n parameter. This is usefull when the
function generates single values (time or unique id for example)

## Examples

``` r
if (FALSE) { # \dontrun{
value <- dm_default(data.model = mydatamodel, name = "date")
} # }
```
