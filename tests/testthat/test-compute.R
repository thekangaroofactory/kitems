

test_that("compute works", {

  # -- baseline
  # suggest / limit / lifecycle will all return their content / args
  expect_identical(unname(compute(x = "suggest(1, 2)")), c(1, 2))

  # -- data masking
  x <- compute(x = "suggest(label)", data = data.frame(label = c("foo", "bar")))
  expect_identical(unname(x), c("foo", "bar"))

  x <- compute(x = "suggest(min(total))", data = data.frame(total = c(12, 10)))
  expect_identical(unname(x), 10)

})
