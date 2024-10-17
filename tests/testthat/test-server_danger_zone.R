

# -- Setup
create_testdata()


# -- Scenario:
test_that("[testServer] Admin UI danger zone works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitemsManager_Server, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs('admin-adm_dz_toggle' = TRUE)

    # -- test output
    expect_type(output$'admin-dm_danger_zone', "list")

  })

})


# -- Cleanup
clean_all(testdata_path)
