

test_that("item_save works", {

  # -- function call
  item_save(data = items, file = items_url)

  # -- check file exists
  expect_true(file.exists(items_url))

})

# -- cleanup data
clean_all()
