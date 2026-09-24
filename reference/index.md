# Package index

## Baseline scenario

These functions are the core features you need to start using the
framework.

### Shiny module server

The main component of the package.

- [`kitems()`](https://thekangaroofactory.github.io/kitems/reference/kitems.md)
  : Kitems Module Server

### Shiny module UI widgets

The UI functions to include into your app.

- [`create_widget()`](https://thekangaroofactory.github.io/kitems/reference/create_widget.md)
  [`update_widget()`](https://thekangaroofactory.github.io/kitems/reference/create_widget.md)
  [`delete_widget()`](https://thekangaroofactory.github.io/kitems/reference/create_widget.md)
  [`actions_widget()`](https://thekangaroofactory.github.io/kitems/reference/create_widget.md)
  : Item Buttons
- [`date_slider_widget()`](https://thekangaroofactory.github.io/kitems/reference/date_slider_widget.md)
  : Date Slider Widget
- [`item_widget()`](https://thekangaroofactory.github.io/kitems/reference/item_widget.md)
  : Item Widget

### Admin

The functions to perform admin tasks.

- [`admin()`](https://thekangaroofactory.github.io/kitems/reference/admin.md)
  : Admin Console

### Demo

Function to list and launch the demo apps.

- [`runExample()`](https://thekangaroofactory.github.io/kitems/reference/runExample.md)
  : Run Shiny Demo Apps

## Advanced scenarios

These helper functions can be used to create events to pass to the
module server reactive arguments.

- [`filter_event()`](https://thekangaroofactory.github.io/kitems/reference/filter_event.md)
  : Filter Event
- [`trigger_event()`](https://thekangaroofactory.github.io/kitems/reference/trigger_event.md)
  : Trigger Event

## Behind the scene

These functions are made available (exported) for advanced users who
would like to go beyond the usage of the module server.

### Data governance

The functions related to data model and config management.

- [`design()`](https://thekangaroofactory.github.io/kitems/reference/design.md)
  : Build YAML Config
- [`extend()`](https://thekangaroofactory.github.io/kitems/reference/extend.md)
  : Extend Item
- [`amend()`](https://thekangaroofactory.github.io/kitems/reference/amend.md)
  : Amend Attribute
- [`shrink()`](https://thekangaroofactory.github.io/kitems/reference/shrink.md)
  : Shrink Config

### Behaviors

The functions related to attribute behavior management.

- [`skip()`](https://thekangaroofactory.github.io/kitems/reference/skip.md)
  [`include()`](https://thekangaroofactory.github.io/kitems/reference/skip.md)
  [`skipped()`](https://thekangaroofactory.github.io/kitems/reference/skip.md)
  [`included()`](https://thekangaroofactory.github.io/kitems/reference/skip.md)
  : Skip Behavior Grammar
- [`refresh()`](https://thekangaroofactory.github.io/kitems/reference/refresh.md)
  [`freeze()`](https://thekangaroofactory.github.io/kitems/reference/refresh.md)
  [`refreshed()`](https://thekangaroofactory.github.io/kitems/reference/refresh.md)
  [`frozen()`](https://thekangaroofactory.github.io/kitems/reference/refresh.md)
  : Refresh Behavior Grammar
- [`hide()`](https://thekangaroofactory.github.io/kitems/reference/hide.md)
  [`display()`](https://thekangaroofactory.github.io/kitems/reference/hide.md)
  [`hidden()`](https://thekangaroofactory.github.io/kitems/reference/hide.md)
  [`displayed()`](https://thekangaroofactory.github.io/kitems/reference/hide.md)
  : Display Behavior Grammar
- [`organize()`](https://thekangaroofactory.github.io/kitems/reference/organize.md)
  [`organized()`](https://thekangaroofactory.github.io/kitems/reference/organize.md)
  : Sort Items Grammar

### Workflows

The functions related to item workflows.

- [`default()`](https://thekangaroofactory.github.io/kitems/reference/default.md)
  : Default Value(s)
- [`as_default()`](https://thekangaroofactory.github.io/kitems/reference/as_default.md)
  : Turn Item Into Default Value(s)
- [`form()`](https://thekangaroofactory.github.io/kitems/reference/form.md)
  : Item Form
- [`dialog()`](https://thekangaroofactory.github.io/kitems/reference/dialog.md)
  : Item Modal Dialog(s)
- [`extract()`](https://thekangaroofactory.github.io/kitems/reference/extract.md)
  : Input Values
- [`prepare()`](https://thekangaroofactory.github.io/kitems/reference/prepare.md)
  : Prepare Values
- [`validate()`](https://thekangaroofactory.github.io/kitems/reference/validate.md)
  : Validate Value(s)
- [`compute()`](https://thekangaroofactory.github.io/kitems/reference/compute.md)
  : Attribute Values
- [`insert()`](https://thekangaroofactory.github.io/kitems/reference/insert.md)
  : Insert Item(s)
- [`update()`](https://thekangaroofactory.github.io/kitems/reference/update.md)
  : Update Item(s)
- [`delete()`](https://thekangaroofactory.github.io/kitems/reference/delete.md)
  : Delete Item(s)
- [`reveal()`](https://thekangaroofactory.github.io/kitems/reference/reveal.md)
  : Reveal Items
- [`decorate()`](https://thekangaroofactory.github.io/kitems/reference/decorate.md)
  : Decorate Item Columns
- [`adjust()`](https://thekangaroofactory.github.io/kitems/reference/adjust.md)
  : Sort Items
- [`yaml_to_dm()`](https://thekangaroofactory.github.io/kitems/reference/yaml_to_dm.md)
  : Config List To Table
- [`item_load()`](https://thekangaroofactory.github.io/kitems/reference/item_load.md)
  : Load Items
- [`item_save()`](https://thekangaroofactory.github.io/kitems/reference/item_save.md)
  : Save Items

### Admin

The functions related to advanced admin tasks.

- [`backup()`](https://thekangaroofactory.github.io/kitems/reference/backup.md)
  : Backup Files
- [`restore()`](https://thekangaroofactory.github.io/kitems/reference/restore.md)
  : Restore Files
- [`check()`](https://thekangaroofactory.github.io/kitems/reference/check.md)
  : Check Integrity
- [`enforce()`](https://thekangaroofactory.github.io/kitems/reference/enforce.md)
  : Item Migration
- [`dm_to_yaml()`](https://thekangaroofactory.github.io/kitems/reference/dm_to_yaml.md)
  : Data Model To YAML
- [`dm_migrate()`](https://thekangaroofactory.github.io/kitems/reference/dm_migrate.md)
  : Data Model Migration
- [`items()`](https://thekangaroofactory.github.io/kitems/reference/items.md)
  **\[experimental\]** : Get Items

### Helpers

These functions are helpers used by the module server.

- [`name()`](https://thekangaroofactory.github.io/kitems/reference/name.md)
  : Kitems Names
- [`attribute_input()`](https://thekangaroofactory.github.io/kitems/reference/attribute_input.md)
  : Attribute Input
- [`has_date_attribute()`](https://thekangaroofactory.github.io/kitems/reference/has_date_attribute.md)
  : Has Date
- [`is_truthy()`](https://thekangaroofactory.github.io/kitems/reference/is_truthy.md)
  : Truthy Value
