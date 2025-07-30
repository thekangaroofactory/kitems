

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: delete item
# --------------------------------------------------------------------------

test_that("Delete works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 trigger = reactiveVal())

  # -- module server call
  testServer(kitems, args = params, {

    # --------------------------------------------------------------------------
    # delete
    # --------------------------------------------------------------------------

    x <- k_items()
    reference <- dim(x)

    # -- create event
    event <- list(workflow = "delete",
                  type = "task",
                  values = k_items()$id[[1]])

    # -- fire dialog
    session$flushReact()
    trigger(event)
    session$flushReact()

    # -- check
    x <- k_items()

    # -- test class
    expect_s3_class(x, "data.frame")

    # -- test dim
    expect_equal(dim(x), reference - c(1, 0))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
