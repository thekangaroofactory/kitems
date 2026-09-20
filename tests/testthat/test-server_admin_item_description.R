
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# update item description from home tab.

create_testdata()

# -- test
test_that("admin_server item desc works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(item_update_description = list(id = "foo")))

    # -- fill input
    session$setInputs(item_update_description_value = "test")

    # -- click
    expect_no_error(
      session$setInputs(item_update_description_confirm = 1))

  })

})

clean_all()
