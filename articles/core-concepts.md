# Core concepts

The framework is based on two main concepts – *data model* and *items*.

## Data Model

The data model contains the specifications of the [Items](#items) to
manage.

For each attribute (column) of the item, the data model carries obvious
information like its name and type, but also a method to determine its
default value as well as constraints and behaviors information to
indicate if it should be skipped in forms, displayed in the table view
or used to sort the data.

Supported types are numeric, integer, logical, character, Date and
POSIXct.

> Note: class POSIXlt is not supported as it stores datetime values into
> a list  
> POSIXct should be used to store datetime attributes.

### Structure

Since version 0.8.0, data models are stored in a (unique) YAML config
file that carries core information for each attribute:

- Name – the name of the attribute
- Type – the type of the attribute
- Class arg. – optional argument passed to the class function
- Default – an optional method to define the default value for the
  attribute
- Values – optional constraints on the attribute value

It also defines behaviors:

- Hide – attributes to be hidden from the table view
- Skip – attributes that will be skipped in the item form
- Refresh – skipped attributes that will be refreshed when the item is
  updated
- Sort – sorting instructions to organize the items

The YAML config can be created / managed using the Admin Console.

### Mandatory attribute

Data models have a mandatory *id* attribute.  
This *id* is the primary key of the item table, here to ensure the
uniqueness of the items.

### Defaults

In many cases, an item may have attributes that do not require an input
from the user:

- to generate a primary key
- to set a default state or date
- because the attribute is internal / hidden

Two mechanisms are available to tune the default behavior:

- default value – a value that fits with the attribute type
- default function – a function to generate the default value (arguments
  can be passed to the function)

The default will be used to initialize the item input form and set the
attribute value in case the user lets the input empty or if the
attribute is skipped.

> **Important**
>
> Whenever an item is created or updated, the input values from the item
> form will be coerced to the type defined in the data model.
>
> Make sure the default can be converted to the expected type or an
> error will be generated.

### Refresh

For attributes that are skipped, it is possible to force them being
re-evaluated upon update.  
The motivation behind this feature is that you may want to have say an
“updated_at” attribute that will be skipped and set to the current date
using the [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html)
function.  
In this case you want the attribute value to be updated if the user
modifies the item.

### Values

It may be interesting to either suggest values to a user for an
attribute or prevent it from getting values that are not allowed.

The mechanism allows three behaviors:

- suggest – values will be suggested to the user in the item form
- limit – user will only be allowed to chose between specific values
- lifecycle – same as limit, with links between the values

## Items

An *item* is defined as – *something that is part of a list or group of
things.*

That is basically the purpose of the package / framework. An item is by
definition anything that belongs to a group of things **defined** by
their data model. This means all the item related functions inside this
package **dynamically** work on the items in the context of their data
model.

As an example, the
[`form()`](https://thekangaroofactory.github.io/kitems/reference/form.md)
function dynamically generates an input form based on the attribute list
contained in the data model (the type of input, the default value of the
input or if no input should be created for the attribute).

*Items* are stored in a reactive object that fits with the data model
rules.  
This means any authoring operation on the items should be performed
**within** the module server except if you decide to run advanced
scenarios directly using the advanced functions of the package.

## Useful Links

- Initialization – see
  [admin](https://thekangaroofactory.github.io/kitems/articles/admin.html#initialization)
- Data model migration – see
  [admin](https://thekangaroofactory.github.io/kitems/articles/admin.html#migration)
- Item workflows – see
  [workflows](https://thekangaroofactory.github.io/kitems/articles/workflows.md)
- Access the data model & items – see
  [shiny-module](https://thekangaroofactory.github.io/kitems/articles/shiny-module.html#return-values)
