
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# When admin console is started with no YAML file.

create_test_folder(testdata_path)

# -- test
test_that("admin_server migration works", {

  # -- module server call
  testServer(admin_server, {

    # -- click to launch migration
    expect_no_error(
      session$setInputs(yaml_create = 1))

  })

})

clean_all()
