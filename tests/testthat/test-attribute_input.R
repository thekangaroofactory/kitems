

test_that("attribute_input works", {

  # -- types
  expect_no_error(x <- attribute_input(name = "note", type = "character", value = "xx"))
  expect_identical(attributes(x)$class, "shiny.tag")

  expect_no_error(x <- attribute_input(name = "total", type = "numeric", value = 10))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "quantity", type = "integer", value = 10L))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "date", type = "Date", value = Sys.Date()))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "created", type = "POSIXct", value = Sys.time()))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "isvalid", type = "logical", value = TRUE))
  expect_identical(attributes(x)$class, "shiny.tag")

  # -- negative tests
  expect_error(attribute_input())
  expect_error(attribute_input(name = "total", type = "dummy"))

})
