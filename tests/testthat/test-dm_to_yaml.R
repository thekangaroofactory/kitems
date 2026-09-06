
test_that("dm_to_yaml works", {

  # -- data
  dm <- data.frame(name = c("id", "valid", "quantity"),
                   type = c("numeric", "logical", "integer"),
                   class.arg = c(NA, NA, NA),
                   default = c("ktools::getTimestamp(k = 1000)", TRUE, NA),
                   display = c(FALSE, TRUE, TRUE),
                   skip = c(TRUE, FALSE, FALSE),
                   refresh = c(FALSE, FALSE, FALSE),
                   sort.rank = c(NA, NA, 1),
                   sort.desc = c(NA, NA, FALSE))
  attributes(dm)$version <- "0.8.0"

  # -- check
  x <- dm_to_yaml(dm)
  expect_type(x, "list")
  expect_length(x$attributes, 3)

})
