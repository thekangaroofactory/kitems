

test_that("dm_version works", {

  # -- alter data model
  dm2 <- dm
  attr(dm2, "version") <- as.character(utils::packageVersion("kitems"))

  # -- tests
  expect_no_warning(x <- dm_version(data.model = dm2))
  expect_equal(x, c(migration = FALSE, comment = "Data model is up to date"))

})


test_that("dm_version: migration @v0.5.2", {

  # -- alter data model
  dm2 <- dm
  attr(dm2, "version") <- "0.5.0"

  # -- tests
  expect_warning(x <- dm_version(data.model = dm2))
  expect_equal(x, c(migration = TRUE, comment = "Data model version is obsolete"))

})


test_that("dm_version: migration @v0.7.1", {

  # -- alter data model
  dm2 <- dm
  attr(dm2, "version") <- "0.7.0"

  # -- tests
  expect_warning(x <- dm_version(data.model = dm2))
  expect_equal(x, c(migration = TRUE, comment = "Data model version is obsolete"))

})
