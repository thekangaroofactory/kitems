

test_that("dm_values works", {

  # -- baseline
  # suggest / limit / lifecycle will all return their content / args
  expect_identical(unname(dm_values(x = "suggest(1, 2)")), c(1, 2))

  # -- data masking
  x <- dm_values(x = "suggest(label)", data = data.frame(label = c("foo", "bar")))
  expect_identical(unname(x), c("foo", "bar"))

  x <- dm_values(x = "suggest(min(total))", data = data.frame(total = c(12, 10)))
  expect_identical(unname(x), 10)

})
