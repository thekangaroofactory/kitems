

# -- Setup
create_testdata()


# -- Scenario:
test_that("[testServer] Create attribute wizard works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems_server, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update inputs
    # case: character attribute
    session$setInputs('admin-w_new_attribute' = 1)

    session$setInputs('admin-w_name' = "test")
    session$setInputs('admin-w_type' = "character")
    session$setInputs('admin-w_confirm_1' = 1)

    # -- case: no default
    session$setInputs('admin-w_default_choice' = "none")
    session$setInputs('admin-w_set_sf' = 1)

    # -- case: skip = FALSE, filter = FALSE
    session$setInputs('admin-w_skip' = FALSE)
    session$setInputs('admin-w_filter' = FALSE)
    session$setInputs('admin-w_set_sort' = 1)

    # -- case: sort = FALSE
    session$setInputs('admin-w_sort' = FALSE)

    session$setInputs('admin-w_ask_confirm' = 1)
    session$setInputs('admin-w_confirm' = 1)

    # - tests
    expect_true("test" %in% k_data_model()$name)
    expect_true("test" %in% names(k_items()))

  })

})


# -- Cleanup
clean_all(testdata_path)
