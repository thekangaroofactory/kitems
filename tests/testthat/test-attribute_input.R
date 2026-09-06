

test_that("attribute_input works", {

  # -- types
  expect_no_error(x <- attribute_input(name = "note", type = "character", value = "xx", ns = shiny::NS("my_data")))
  expect_identical(attributes(x)$class, "shiny.tag")

  expect_no_error(x <- attribute_input(name = "total", type = "numeric", value = 10, ns = shiny::NS("my_data")))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "quantity", type = "integer", value = 10L, ns = shiny::NS("my_data")))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "date", type = "Date", value = Sys.Date(), ns = shiny::NS("my_data")))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "created", type = "POSIXct", value = Sys.time(), ns = shiny::NS("my_data")))
  expect_identical(attributes(x)$class, "shiny.tag")
  expect_no_error(x <- attribute_input(name = "isvalid", type = "logical", value = TRUE, ns = shiny::NS("my_data")))
  expect_identical(attributes(x)$class, "shiny.tag")

  # -- negative tests
  expect_error(attribute_input())
  expect_error(attribute_input(name = "total", type = "dummy"))

})
