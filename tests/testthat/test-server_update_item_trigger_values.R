

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: update item
# --------------------------------------------------------------------------

test_that("Update works [trigger dialog]", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 trigger = reactiveVal())

  # -- module server call
  testServer(kitems, args = params, {

    # -- get items
    x <- k_items()
    reference <- dim(x)

    # -- flush reactive values
    session$flushReact()

    # -- select item
    trigger(list(workflow = "update",
                 type = "task",
                 values = list(id = x$id[1],
                               date = x$date[1] + 1,
                               name = paste0(x$name[1], "-updated"),
                               quantity = x$quantity[1] + 10,
                               total = x$total[1] + 0.5,
                               isvalid = !x$isvalid[1])))


    session$flushReact()

    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), reference)

    # -- test name
    expect_true(grepl("updated", x$name[1], fixed = TRUE))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
