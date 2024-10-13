

# -- setup
data.model <- data.frame(name = c("id", "name"),
                         type = c("numeric", "character"))

missing_col <- names(DATA_MODEL_COLCLASSES[!names(DATA_MODEL_COLCLASSES) %in% names(data.model)])


test_that("dm_migrate works", {

  # -- function call
  x <- dm_migrate(data.model, missing_col)

  # -- check
  expect_equal(names(x), names(DATA_MODEL_COLCLASSES))

})
