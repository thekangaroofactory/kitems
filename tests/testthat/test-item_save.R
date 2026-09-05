

test_that("item_save works", {

  # -- function call
  item_save(data = items,  connector = list(file = name(id, url = T)))

  # -- check file exists
  expect_true(file.exists(name(id, url = T)))

})

# -- cleanup data
clean_all()
