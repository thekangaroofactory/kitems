

test_that("item_add works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = FALSE)

  # -- module server call
  testServer(kitems_server, args = params, {

    x <- reactiveVal(items)

    # -- function call
    item_add(x, new_item)

    # -- test class
    expect_s3_class(x(), "data.frame")

    # -- test dim
    expect_equal(dim(x()), dim(items) + c(1, 0))

    # -- test added attribute
    #expect_equal(x[x$name == new_item$name, ]$total, new_item$total)

  })

})
