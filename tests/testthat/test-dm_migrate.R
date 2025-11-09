

test_that("dm_migrate works", {

  # -- alter data model
  dm2 <- dm
  attr(dm2, "version") <- as.character(packageVersion("kitems"))

  # -- function call
  expect_no_message(x <- dm_migrate(dm2))

  # -- check
  expect_true(is.na(x))

})


test_that("dm_migrate: migration @v0.5.2", {

  # -- alter data model
  dm2 <- dm
  dm2[c("default.arg", "sort.rank", "sort.desc")] <- NULL
  attr(dm2, "version") <- "0.5.0"

  # -- function call
  expect_message(x <- dm_migrate(data.model = dm2))

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- checks:
  expect_true("default.arg" %in% names(x))
  expect_true("sort.rank" %in% names(x))
  expect_true("sort.desc" %in% names(x))
  expect_true(attributes(x)$version == "0.5.2")

})


test_that("dm_migrate: migration @v0.7.1", {

  # -- alter data model
  names(dm)[names(dm) == "display"] <- "filter"
  attr(dm, "version") <- "0.7.0"

  # -- function call
  expect_message(x <- dm_migrate(data.model = dm))

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_true("display" %in% names(x))
  expect_false("filter" %in% names(x))
  expect_true(attributes(x)$version == "0.7.1")

})
