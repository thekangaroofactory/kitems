
create_folder()

test_that("Grammar organize works", {

  # baseline
  config <- design(project = "test", item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "total", type = "integer"))

  # test
  # just test call as deeper coverage should be done in config_item_sort
  expect_no_warning(organize(config, item = "foo", sort = "total"))

})

clean_all()
