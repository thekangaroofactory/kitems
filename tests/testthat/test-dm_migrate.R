

# -- setup (basic test to see if version is updated)
data.model <- data.frame(name = c("id", "name"),
                         type = c("numeric", "character"))
attr(data.model, "version") <- "0.7.0"


test_that("dm_migrate works", {

  # -- function call
  x <- dm_migrate(data.model)

  # -- check
  expect_true(attributes(x)$version == as.character(packageVersion("kitems")))

})
