# Constraints

Constraints can be defined to control the way attribute values are
managed.

## Attribute values

By default, an attribute can get any values that fits with its type (and
by extension any value that can be coerced to its type).

Let’s take an example.  
If `quantity` is defined as an `integer`, it will accept for example
`12L` but also `12` or `"12"` because the validation process will detect
the wrong type and coerce the numeric or character value into an
integer.

No say you have a `group` character attribute that should only gets a
value among identified groups (say A, B and C). You need to put some
constraint on the attribute to prevent the user from typing values out
of this list of options.

The attribute values mechanism allows to set such a list, but also
enable three different behaviors:

- suggest
- limit
- lifecyle

### Suggest

By setting a *suggest* constraint on the attribute values, you activate
a behavior that replaces the former “shortcut” behavior (shortcut links
would be displayed next to the attribute input to fill it with the
clicked option).

The defined list of values will be suggested to the user inside the
attribute input[^1].  
It will get a drop down list of suggestions, and allow user to type in
something else as well.

Because the options in the attribute values list are just suggestions,
no validation will be done after the form is confirmed[^2].

Example:  
`suggest("A", "B", "C")`

### Limit

The *limit* constraint will not only propose options to the user but
force the selection to be made inside the given list. The select input
will block from typing values that are not in this list.

In case the create or update workflow is performed using the back-end
trigger (i.e. without displaying the item form), a validation process
will prevent from passing values out of the list of accepted options.

> **Note**
>
> In case a value out of the list is passed to the trigger, it will be
> replaced by the default one which is the first element of the list.

Example:  
`limit("A", "B", "C")`

### Lifecycle

The third and last constraint behavior is *lifecycle*.  
At this time, it does the same thing as *limit*, but the intention
behind is to enable mechanisms where the values are linked to each
others[^3].

A good example would be a `state` attribute that receives options like
‘draft’, ‘in-work’ and ‘done’.

Example:  
`limit("draft", "in-work", "done")`

## Data masking

The above examples are based on hard coded values, but the mechanism
also allows to use computed ones:

- based on function call
- with or without data masking

Say you want to suggest values computed on given parameters, you may use
something like:  
`suggest(format(Sys.time(), "%Hh%M"))`

The expression will be evaluated to get the option value (something like
“10h03”).

Now say that you want to suggest (or limit) options based on another
attribute (column) of the item table:  
`suggest(min(quantity), mean(quantity), median(quantity), max(quantity))`

These expressions will be evaluated and computed based on the `quantity`
attribute and the item form will suggest the min, mean, median and max
values in the corresponding input.

Of course, custom functions are accepted as long as they can be reached
in the environment:  
`limit(foo())`will limit the possible input to whatever the `foo`
function produces.

## Activation

To activate the attribute values mechanism, you need to launch the Admin
Console app and create or update an attribute. The attribute wizard has
a step dedicated to this feature.

It will update the YAML config accordingly.

## Useful links

- Admin console –
  [admin](https://thekangaroofactory.github.io/kitems/articles/admin.html#data-model)

[^1]: Which will be turned into a selectInput, no matter what the
    attribute type is.

[^2]: No validation on this particular topic, other validation will be
    done as usual.

[^3]: The reason why it has been introduced in version 0.8.0 is that it
    will allow adding features in minor revisions without upgrading the
    YAML config structure.
