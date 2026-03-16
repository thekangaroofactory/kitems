

test_that("attribute_delete works", {

  # -- function call
  x <- attribute_delete(data.model = dm, name = "isvalid", items = items)

  # -- checks
  expect_type(x, "list")
  expect_s3_class(x$data.model, "data.frame")
  expect_s3_class(x$items, "data.frame")
  expect_false("isvalid" %in% x$data.model$name)
  expect_false("isvalid" %in% colnames(x$items))

})


test_that("attribute_delete all", {

  # -- function call
  x <- dm
  y <- items
  for(name in x$name){
    rv <- attribute_delete(data.model = x, name, y)
    x <- rv$data.model
    y <- rv$items}

  # -- checks
  expect_null(x)
  expect_null(y)

})
