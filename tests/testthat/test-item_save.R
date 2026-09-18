

create_test_folder(testdata_path)

test_that("item_save works", {

  # -- negative test
  expect_no_error(
    item_save(data = NULL,
              connector = list(path = dirname(name(module_id, url = T)),
                               file = basename(name(module_id, url = T)))))

  # -- function call
  item_save(data = items,  connector = list(file = name(module_id, url = T)))

  # -- check file exists
  expect_true(file.exists(name(module_id, url = T)))

})

# -- cleanup data
clean_all()
