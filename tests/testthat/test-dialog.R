

test_that("dialog works", {

  x <- dialog("", ns = shiny::NS("id"))
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

})
