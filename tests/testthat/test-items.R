

create_testdata()

test_that("items works", {

  # -- secure
  expect_error(items(datamart = NULL, config, item = "foo"))

  # -- load item
  expect_message(x <- items(datamart = list(), config, item = "foo"))
  expect_s3_class(x, "data.frame")
  expect_true(nrow(x) > 0)

})

clean_all()
