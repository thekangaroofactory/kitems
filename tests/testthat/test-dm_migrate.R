

old_dm <- data.frame(name = c("id", "name", "interal"),
                  type = c("numeric", "character", "logical"),
                  default.val = NA,
                  default.fun = c("ktools::getTimestamp", NA, NA),
                  default.arg = NA,
                  display = c(FALSE, TRUE, TRUE),
                  skip = c(TRUE, FALSE, FALSE),
                  sort.rank = NA,
                  sort.desc = NA)
attr(old_dm, "version") <- "0.5.0"


test_that("dm_migrate works", {

  # -- no migration needed
  attr(old_dm, "version") <- as.character(utils::packageVersion("kitems"))

  # -- tests
  expect_no_message(x <- dm_migrate(old_dm))
  expect_true(is.na(x))

})


test_that("dm_migrate: migration @v0.5.2", {

  # -- alter data model
  old_dm[c("default.arg", "sort.rank", "sort.desc")] <- NULL
  attr(old_dm, "version") <- "0.5.0"

  # -- function call
  expect_message(x <- dm_migrate(data.model = old_dm))
  expect_s3_class(x, "data.frame")
  expect_true("sort.rank" %in% names(x))
  expect_true("sort.desc" %in% names(x))
  expect_true(attributes(x)$version == utils::packageVersion("kitems"))

})


test_that("dm_migrate: migration @v0.7.1", {

  # -- alter data model
  names(old_dm)[names(old_dm) == "display"] <- "filter"
  attr(old_dm, "version") <- "0.7.0"

  # -- function call
  expect_message(x <- dm_migrate(data.model = old_dm))

  # -- checks
  expect_s3_class(x, "data.frame")
  expect_true("display" %in% names(x))
  expect_false("filter" %in% names(x))
  expect_true(attributes(x)$version == utils::packageVersion("kitems"))

})


test_that("dm_migrate: migration @v0.8.0", {

  # -- alter data model
  old_dm[c("class.arg", "values", "refresh", "default")] <- NULL
  old_dm[1, "default.fun"] <- "getTimestamp"
  old_dm[1, "default.arg"] <- "list(k = 1000)"
  old_dm[1, "default.val"] <- NA
  attr(old_dm, "version") <- "0.7.1"

  # -- tests
  expect_message(x <- dm_migrate(data.model = old_dm))
  expect_s3_class(x, "data.frame")

  # -- checks
  expect_true("display" %in% names(x))
  expect_false("filter" %in% names(x))
  expect_identical(x$default, c("getTimestamp(k = 1000)", NA, NA))
  expect_true(attributes(x)$version == utils::packageVersion("kitems"))

})
