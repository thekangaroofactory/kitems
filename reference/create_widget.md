# Item Buttons

Action button(s) to fire the item dialog.

## Usage

``` r
create_widget(id)

update_widget(id)

delete_widget(id)

actions_widget(id)
```

## Arguments

- id:

  the server module id.

## Value

An HTML tag.

## Details

`id` is the namespace of the module server instance holding the target
item.

- create_widget() to fire create dialog

- update_widget() to fire update dialog

- delete_widget() to fire delete dialog

- actions_widget() is a wrapper that returns all there buttons.

## Examples

``` r
if (FALSE) { # \dontrun{
# assuming the module server has been launched with id = "mydata"
create_widget(id = "mydata")
} # }
```
