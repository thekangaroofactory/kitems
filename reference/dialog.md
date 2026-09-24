# Item Modal Dialog(s)

Produces a create / update / delete modal dialog.

## Usage

``` r
dialog(
  ...,
  workflow = c("create", "update", "delete"),
  session = getDefaultReactiveDomain()
)
```

## Arguments

- ...:

  the content to be displayed in the modal dialog.

- workflow:

  a character string to indicate workflow (see details).

- session:

  optional, the shiny session object.

## Value

a modal dialog.

## Details

Possible values for workflow are "create" (default), "update" or
"delete".

`...` is typically the output of the
[`form()`](https://thekangaroofactory.github.io/kitems/reference/form.md)
function. When `workflow = "delete"`, it will be ignored and replaced by
a standard message.

## Examples

``` r
if (FALSE) { # \dontrun{
dialog(workflow = "delete")
} # }
```
