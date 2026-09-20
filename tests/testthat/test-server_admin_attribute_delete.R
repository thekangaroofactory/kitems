
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Update attribute.

create_testdata()

# -- test
test_that("admin_server attribute_update works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(attribute_action = list(item = "foo", action = "delete", id = "total")))

    # -- fill inputs
    session$setInputs(attribute_delete_string = "delete-total")

    # -- click
    expect_no_error(
      session$setInputs(attribute_delete_confirm = 1))

  })

})

clean_all()
