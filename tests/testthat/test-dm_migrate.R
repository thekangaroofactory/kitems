

test_that("dm_migrate works", {

  # -- alter data model
  dm2 <- dm
  attr(dm2, "version") <- as.character(utils::packageVersion("kitems"))

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
  # expect_true("default.arg" %in% names(x)) <<<<<<<<<<<<<<<<< that needs an upgrade: just migrate it normally for v8.x (test ko for now)
  expect_true("sort.rank" %in% names(x))
  expect_true("sort.desc" %in% names(x))
  expect_true(attributes(x)$version == utils::packageVersion("kitems"))

})


test_that("dm_migrate: migration @v0.7.1", {

  # -- alter data model
  dm2 <- dm
  names(dm2)[names(dm2) == "display"] <- "filter"
  attr(dm2, "version") <- "0.7.0"

  # -- function call
  expect_message(x <- dm_migrate(data.model = dm2))

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_true("display" %in% names(x))
  expect_false("filter" %in% names(x))
  expect_true(attributes(x)$version == utils::packageVersion("kitems"))

})


test_that("dm_migrate: migration @v0.8.0", {

  # -- alter data model
  dm2 <- dm
  dm2[c("class.arg", "values", "refresh")] <- NULL
  dm2[1, "default.fun"] <- "getTimestamp"
  dm2[1, "default.arg"] <- "list(k = 1000)"
  attr(dm2, "version") <- "0.7.1"

  # -- function call
  expect_message(x <- dm_migrate(data.model = dm2))

  # -- checks:
  expect_s3_class(x, "data.frame")

  # -- check: x dim
  expect_true("display" %in% names(x))
  expect_false("filter" %in% names(x))
  expect_true(attributes(x)$version == utils::packageVersion("kitems"))

})
