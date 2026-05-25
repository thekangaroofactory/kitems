# item_integrity / error (fix)

    Code
      x <- item_integrity(items = items, data.model = dm, fix = TRUE)
    Condition
      Warning in `FUN()`:
      Attribute date class does not match with data model: 
      -- items class = character vs data.model type = Date
      Warning in `value[[3L]]()`:
      Coerce date to Date did not work!
    Message
      >> Check after conversion:NULL

# item_integrity / warning (fix)

    Code
      x <- item_integrity(items = items, data.model = dm, fix = TRUE)
    Condition
      Warning in `FUN()`:
      Attribute name class does not match with data model: 
      -- items class = character vs data.model type = numeric
      Warning in `value[[3L]]()`:
      NAs introduced by coercion
    Message
      >> Check after conversion:NULL

