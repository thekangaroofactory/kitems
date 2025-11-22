
<!-- You need to render `README.Rmd` to keep `README.md` up-to-date. -->

# kitems

<!-- badges: start / keep here because it's not displayed the same way in GitHub & pkgdown -->

[![R-CMD-check](https://github.com/thekangaroofactory/kitems/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/thekangaroofactory/kitems/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/thekangaroofactory/kitems/graph/badge.svg?token=7P74NK51JJ)](https://codecov.io/gh/thekangaroofactory/kitems)
<!-- badges: end -->

The goal of kitems is to provide a framework to manage data frame
*items* and a set of tools to implement it within R Shiny applications.

It is delivered as a Shiny module.

## Lifecycle

<!-- badge: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badge: end -->

> Note that the package is under development convergence (lifecycle =
> experimental).  
> Core features may still be modified at this stage, and there is no
> guaranty that exported functions signature will not change before it
> is converged.

See xxx to get more information about the package roadmap.

## Installation

The development (*beta*) version of kitems can be installed from
[GitHub](https://github.com/thekangaroofactory/kitems) with:

``` r
# install.packages("devtools")
devtools::install_github("thekangaroofactory/kitems")
```

## Demo

Demo apps are delivered along with the package and can be accessed with:

``` r
# -- get demo names
kitems::runExample()

# -- run 'demo' app
kitems::runExample("demo")
```

## Data model

### Checking integrity

When the module server is launched, it will perform an integrity check
to ensure that the *items* and data model are synchronized.

If not, the data model will be updated to match with any missing
attribute for example.  
Items will be checked as well to make sure attribute types fit with the
data model.

## Item management

The *create* and *update* buttons triggers a dynamic form that is built
based on the data model.  
Attributes defined as *skipped* won’t get an input in the form.  
The inputs are initialized with the default values or output of the
default functions when defined.  
After the form is completed, a check is performed to make sure values
match the attribute types.  
If no value is provided for an attribute, the default is applied.
