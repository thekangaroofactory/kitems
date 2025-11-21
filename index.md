# kitems

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

The goal of kitems is to provide a framework to manage data frame
*items* and a set of tools to implement it within R Shiny applications.

It is delivered as a Shiny module.

> Note that the package is under development convergence (lifecycle =
> experimental).  
> Core features may still be modified at this stage, and there is no
> guaranty that exported functions signature will not change before it
> is converged.

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

Path

Both data model & item files are stored in a specific folder dedicated
to that instance of the module.The folder is named after the id of the
module.

For this reason, unless there is a single instance of the module, it is
not recommended to name any of the id with same name as the last folder
of the provided path.

Example:

path = “./path/to/data” & id = “data” will store files in
“./path/to/data”

path = “./path/to/data” & id = “data_1” will store files in
“./path/to/data/data_1”

It may result in files being stored at different levels.

## Data model

### Initialization

When starting the module with id and path arguments, it will check if
the corresponding data model is available in the destination path.

If no data model is found, the admin console UI will display a button to
create a new data model, as well as a button to import data (it creates
the data model from the data).

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
