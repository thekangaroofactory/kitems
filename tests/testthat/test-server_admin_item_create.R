
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Switch to item tab from home tab.

create_testdata()

# -- test
test_that("admin_server item create works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(item_create = 1))

    # -- fill input
    session$setInputs(item_name = "")
    session$setInputs(item_name = "aa?jj")
    session$setInputs(item_name = "foo")
    session$setInputs(item_name = "bar")

    # -- click
    expect_no_error(
      session$setInputs(item_create_confirm = 1))

  })

})

clean_all()
