

expect_items <- function(x, n = 1){

  # -- check class
  expect_s3_class(x, "data.frame")

  # -- check dim (single row)
  expect_equal(nrow(x), n)

}


expect_colclasses <- function(x, colClasses){

  # -- check dim (columns)
  expect_equal(ncol(x), length(colClasses))

  # -- check names
  expect_true(all(names(colClasses) %in% names(x)))

  # -- check classes
  # check first attribute as POSIXct gets "POSIXct" "POSIXt"
  for(col in names(x))
    expect_equal(class(x[[col]])[1], colClasses[[col]])

}
