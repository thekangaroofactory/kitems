# Administration

The framework provides administration capabilities that mostly (but not
only) cover data model tasks.

## Admin console

An administration console is delivered as a standalone Shiny app within
the package.

The main reason is that in most cases, it’s not recommended to have the
data model(s) management accessible from within the application. Another
reason is that administration tasks are not expected to be performed on
regular bases. Hence there is no need to have the main module server and
the session overloaded with reactives & observers that won’t be called
in the daily scenarios.

To run the app, use the
[`admin()`](https://thekangaroofactory.github.io/kitems/reference/admin.md)
function:

``` r
kitems::admin(path = "path/to/data")
```

The admin console gives access to all the data models belonging to the
`path` argument in one place. One tab per data model will be displayed
inside the UI.

### Features

#### Data model

The data model section displays a table of the attributes:

![](images/admin_data_model.png)

From here, it’s possible to create or update (after row selection) an
attribute thanks to the attribute wizard:

![](images/admin_att_wizard.png)

It is meant to guide you through the attribute creation and perform
checks (in particular at the default value step).

The danger zone toggle allows to access to actions that cannot be
undone:

![](images/admin_danger.png)

> **Caution**
>
> - Deleting an argument will delete the corresponding column in the
>   item table!
>
> - Deleting a data model will delete the corresponding item table!
>
> These actions cannot be undone…

#### Raw table

The raw table section displays the item table as-is (hidden attributes
are displayed).

![](images/admin_raw_table.png)

It’s possible to reorder the attributes (hence the items columns) from
here.

#### View

The view section displays the item table as it will be available from
the
[`filtered_view_widget()`](https://thekangaroofactory.github.io/kitems/reference/filtered_view_widget.md)
function:

![](images/admin_view.png)

- only attributes with `display = TRUE` are visible

- mask is applied on column names (replace . and \_ with space,
  capitalize first letter)

You can add or remove attributes to be hidden from this view (or update
the attribute in the data model section).

### Initialization

When the console detects an empty folder inside the provided path, it
will allow you to create a new data model:

![](images/admin_scratch.png)

You can create one from scratch or import existing data (see next
section).

### Data import

It is possible to import existing data (and create the corresponding
data model) through a wizard.

- Select the file to import (.csv)

![](images/admin_import_1.png)

- Check the items preview

![](images/admin_import_2.png)

- Check the extracted data model

![](images/admin_import_3.png)

- Validate import

> **Important**
>
> At this stage, the import process is not very flexible as it does not
> allow to tune the extracted data model, or select specific columns of
> the data. This needs to be done manually in a second step.
>
> There is a known bug / problem after the select file step:  
> In case the data does not contain an “id” column, unique ids will be
> generated but performances are poor when data contains many rows.
>
> See issue [Generate unique ids is slow during data
> import](https://github.com/thekangaroofactory/kitems/issues/552)

### Migration

As of version
[v0.7.1](https://github.com/thekangaroofactory/kitems/releases/tag/v0.7.1-beta),
data models now carry a version that corresponds to the latest data
model structure update.

Whenever the module server detects either a data model without any
version or with an obsolete version number, it will raise a warning
dialog and ask for the app to be closed.

Data model migration is performed through the admin console. It will
detect when a migration is required and display a button to run the
migration procedure.

> **Tip**
>
> It is recommended to run the admin console after a package upgrade to
> check whether a migration is needed or not.
>
> It is also recommended to check the
> [Changelog](https://thekangaroofactory.github.io/kitems/news/index.md)
> page.

## Behind the scene

Because the package is meant to be as flexible as possible, it is
possible to access the admin components from exported functions.

> **Caution**
>
> That being said, it is not recommended to wrap the admin console
> inside your app as it should be kept out of the users.

### Admin module server

The module server function is delivered as
[`kitems_admin()`](https://thekangaroofactory.github.io/kitems/reference/kitems_admin.md)
.

### Admin UI

The module UI component is wrapped in the
[`admin_widget()`](https://thekangaroofactory.github.io/kitems/reference/admin_widget.md)
function.

## Useful Links

- admin parameter: [Shiny
  module](https://thekangaroofactory.github.io/kitems/articles/shiny-module.html#admin)
