
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Delete item & danger zone.

create_testdata()

# -- test
test_that("admin_server item delete works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(item_delete = "foo-delete_x"))

    # -- fill input
    session$setInputs(item_delete_string = "delete-foo")

    # -- click
    expect_no_error(
      session$setInputs(item_delete_confirm = 1))

  })

})

clean_all()
