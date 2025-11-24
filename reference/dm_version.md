# Data Model Version

Check data model version

## Usage

``` r
dm_version(data.model)
```

## Arguments

- data.model:

  a data.frame of the data model.

## Value

A vector `c(migration = TRUE/FALSE, comment = "message")`.

## Details

Data model version is required from v.0.7.1 This function will check
whether the data model has a version (attribute) or not as well as if
the data model requires a migration.

It works both within a Shiny app context or at the console It is
recommended that this check is performed after installing a new version
of the package.

## Examples

``` r
if (FALSE) { # \dontrun{
dm_version(data.model = mydatamodel)
} # }
```
