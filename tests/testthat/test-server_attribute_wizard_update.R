

# -- Setup
create_testdata()


# -- Scenario:
test_that("[testServer] Update attribute wizard works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 autosave = TRUE,
                 admin = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update inputs
    # case: character attribute
    session$setInputs('admin-dm_table_rows_selected' = 3)
    session$setInputs('admin-update_attribute' = 1)

    # -- case: no default
    session$setInputs('admin-wizard-w_default_choice' = "none")
    session$setInputs('admin-wizard-w_set_sf' = 1)
    session$setInputs('admin-wizard-w_skip' = FALSE)
    session$setInputs('admin-wizard-w_filter' = FALSE)
    session$setInputs('admin-wizard-w_set_sort' = 1)
    session$setInputs('admin-wizard-w_sort' = FALSE)
    session$setInputs('admin-wizard-w_ask_confirm' = 1)
    session$setInputs('admin-wizard-w_confirm' = 1)

    # - tests
    expect_true("name" %in% k_data_model()$name)
    expect_true("name" %in% names(k_items()))

  })

})


# -- Cleanup
clean_all()
