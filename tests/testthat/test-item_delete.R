

test_that("item_delete", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = FALSE)

  # -- module server call
  testServer(kitems_server, args = params, {

    x <- reactiveVal(items)

    # -- function call
    item_delete(items = x, id = item_id)

    # -- test class
    expect_s3_class(x(), "data.frame")

    # -- test dim
    expect_equal(dim(x()), dim(items) - c(1, 0))

    # -- test missing id
    expect_false(item_id %in% x()$id)

  })

})
