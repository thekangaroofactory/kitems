# Import data works

    Code
      session$setInputs(`admin-import-dm_confirm` = 1)
    Condition
      Warning in `FUN()`:
      Attribute date class does not match with data model: 
      -- items class = POSIXct vs data.model type = Date
    Message
      >> Check after conversion:Date
    Condition
      Warning in `FUN()`:
      Attribute quantity class does not match with data model: 
      -- items class = numeric vs data.model type = integer
    Message
      >> Check after conversion:integer

