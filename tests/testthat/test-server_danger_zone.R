

# -- Setup
create_testdata()


# -- Scenario:
test_that("[testServer] Admin UI danger zone works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE,
                 admin = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs('admin-dz_toggle_btn' = TRUE)

    # -- test output
    expect_type(output$'admin-danger_zone', "list")

  })

})


# -- Cleanup
clean_all(testdata_path)
