# Date Slider Widget

The UI component to drive the date filter.

## Usage

``` r
date_slider_widget(id, width = "300px", bootstrap = bslib::version_default())
```

## Arguments

- id:

  the server module id.

- width:

  the width of the input (passed to
  [`shiny::sliderInput()`](https://rdrr.io/pkg/shiny/man/sliderInput.html)).

- bootstrap:

  optional, a character string for the Bootstrap major version (see
  details).

## Value

An HTML tag.

## Details

`bootstrap` has been added in version 0.8.0 to determine if
[`bslib::popover()`](https://rstudio.github.io/bslib/reference/popover.html)
can be used in the widget. The default is provided by
[`bslib::version_default()`](https://rstudio.github.io/bslib/reference/versions.html),
but there is no obvious way to know - from the UI side - if the app uses
shiny's default or bslib layouts.

In case you are using shiny's layout (ex:
[`shiny::fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)),
you should set the parameter to `bootstrap = "3"`.

## Examples

``` r
if (FALSE) { # \dontrun{
# with bslib or Bootstrap 5 in general
date_slider_widget(id = "mydata")

# with Bootstrap 3
date_slider_widget(id = "mydata", bootstrap = "3")
} # }
```
