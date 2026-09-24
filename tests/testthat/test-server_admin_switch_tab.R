
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Switch to item tab from home tab.

create_testdata()

# -- test
test_that("admin_server switch tab works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(select_tab = list(id = "foo")))

  })

})

clean_all()
