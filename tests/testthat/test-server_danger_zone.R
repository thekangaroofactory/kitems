

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
  testServer(kitems_server, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs('admin-dz_toggle' = TRUE)

    # -- test output
    expect_type(output$'admin-danger_zone', "list")

  })

})


# -- Cleanup
clean_all(testdata_path)
