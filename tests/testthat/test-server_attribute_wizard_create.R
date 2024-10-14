

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
  testServer(kitemsManager_Server, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update inputs
    # case: character attribute
    session$setInputs(w_new_attribute = 1)

    session$setInputs(w_name = "test")
    session$setInputs(w_type = "character")
    session$setInputs(w_confirm_1 = 1)

    # -- case: no default
    session$setInputs(w_default_choice = "none")
    session$setInputs(w_set_sf = 1)

    # -- case: skip = FALSE, filter = FALSE
    session$setInputs(w_skip = FALSE)
    session$setInputs(w_filter = FALSE)
    session$setInputs(w_set_sort = 1)

    # -- case: sort = FALSE
    session$setInputs(w_sort = FALSE)

    session$setInputs(w_ask_confirm = 1)
    session$setInputs(w_confirm = 1)

    # - tests
    expect_true("test" %in% k_data_model()$name)
    expect_true("test" %in% names(k_items()))

  })

})


# -- Cleanup
clean_all(testdata_path)
