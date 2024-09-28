

test_that("item_update works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = FALSE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- init
    x <- reactiveVal(items)

    # -- function call
    item_update(items = x, item = update_item)

    # -- test class
    expect_s3_class(x(), "data.frame")

    # -- test dim
    expect_equal(dim(x()), dim(items))

    # -- test updated name
    expect_equal(x()[x()$id == update_item$id, ]$name, "Apple-update")

  })

})
