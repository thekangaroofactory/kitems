

test_that("multiplication works", {

  # -- function call
  x <- item_add(items, item_new)

  # -- test class
  expect_s3_class(x, "data.frame")

  # -- test dim
  expect_equal(dim(x), c(5,4))

  # -- test added attribute
  expect_equal(unlist(x[x$name == "Mango", ]), c(id = "170539948521", date = "19747", name = "Mango", isvalid = "TRUE"))

})
