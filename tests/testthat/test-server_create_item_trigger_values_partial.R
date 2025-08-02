

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario: create item
# --------------------------------------------------------------------------

test_that("Create item [trigger]", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 trigger = reactiveVal(NULL))

  # -- module server call
  testServer(kitems, args = params, {

    # -- prepare event
    event <- list(workflow = "create",
                  type = "task",
                  values = list(name = "Orange",
                                total = 78.9,
                                isvalid = FALSE))

    # -- hit trigger
    session$flushReact()
    trigger(event)
    session$flushReact()


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(items) + c(1, 0))

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
