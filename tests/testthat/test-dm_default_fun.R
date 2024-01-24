

test_that("multiplication works", {

  # -- function call
  x <- dm_default_fun(data.model = dm)

  # -- test
  expect_mapequal(x, c(date = "Sys.Date"))

})
