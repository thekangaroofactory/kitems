# Known Limitations

## Limitations

This article is dedicated to listing known limitations that are not -
*at this time* - expected to be fixed.

- Prior to R-4.3.0,
  [`attribute_value()`](https://thekangaroofactory.github.io/kitems/reference/attribute_value.md)
  function may raise an error when the first element of a POSIXct vector
  set as `value` parameter is NA. This is due to missing origin in the
  call to as.POSIXct.

  From R-4.3.0, origin is no longer a required parameter:  
  <https://stackoverflow.com/questions/37690722/how-to-get-origin-from-posixct-object>

  This impacts the create & update trigger workflows (see
  [`vignette("workflows")`](https://thekangaroofactory.github.io/kitems/articles/workflows.md)).

  To bypass this issue, make sure the values sent to the trigger for
  POSIXct attributes fits with the expected class (at least the first
  element of the vector):

  ``` r
  # -- first element not NA
  class(c(Sys.time(), NA))
  ```

      [1] "POSIXct" "POSIXt" 

  ``` r
  # -- first element NA
  class(c(NA, Sys.time()))
  ```

      [1] "numeric"

  In the second case, even after `NA` is replaced by the default value
  out of the data model, the vector will keep the numeric type. The
  function will detect it and perform a type conversion to fit with the
  data model by calling `as.POSIXct` with the arguments given in the
  data model. Passing origin to the data model default function should
  also solve the problem.
