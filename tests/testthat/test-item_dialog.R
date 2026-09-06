

test_that("item_dialog works", {

  x <- item_dialog("", ns = shiny::NS("id"))
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

})
