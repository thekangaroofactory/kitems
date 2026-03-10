

# -- Setup
create_testdata()


# -- Scenario:
test_that("[testServer] Delete data model works", {

  # -- declare arguments
  params <- list(id = module_id, options = list(admin = TRUE))

  # -- module server call
  testServer(kitems, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs('admin-dz_delete_dm' = 1)
    session$setInputs('admin-dz_delete_dm_string' = "delete_data")
    session$setInputs('admin-dz_delete_dm_items' = TRUE)
    session$setInputs('admin-dz_delete_dm_confirm' = 1)

    # - tests
    expect_null(k_data_model())
    expect_null(k_items())
    expect_false(file.exists(dm_url(module_id)))
    expect_false(file.exists(items_url(module_id)))

  })

})


# -- Cleanup
clean_all()
