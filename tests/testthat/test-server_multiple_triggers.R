

# --------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------

create_testdata()


# --------------------------------------------------------------------------
# Scenario:
# --------------------------------------------------------------------------

test_that("Multiple triggers work", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 trigger = reactiveVal(NULL))

  # -- module server call
  testServer(kitems, args = params, {

    # -- prepare event
    events <- list(list(workflow = "create",
                  type = "task",
                  values = list(id = NA,
                                date = Sys.time(),
                                name = "Pineapple",
                                quantity = 4,
                                total = 78.9,
                                isvalid = FALSE)),
                  list(workflow = "update",
                       type = "task",
                       values = list(id = k_items()[k_items()$name == "Banana", ]$id,
                                     quantity = 99,
                                     total = 777,
                                     isvalid = TRUE)))

    # -- hit trigger
    session$flushReact()
    trigger(events)
    session$flushReact()


    # --------------------------------------------------------------------------
    # Items
    # --------------------------------------------------------------------------

    x <- k_items()

    # -- test class & dim
    expect_s3_class(x, "data.frame")
    expect_equal(dim(x), dim(items) + c(1, 0))
    expect_equal(x[x$name == "Banana", ]$quantity, 99)
    expect_equal(x[x$name == "Banana", ]$total, 777)

  })

})


# --------------------------------------------------------------------------
# Cleanup
# --------------------------------------------------------------------------

clean_all()
