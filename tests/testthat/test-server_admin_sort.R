
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Sorting.

create_testdata()

# -- test
test_that("admin_server sorting works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(sorting_action = list(id = "foo")))

    # -- fill inputs
    session$setInputs(item_ordering = "date")

    # -- click
    expect_no_error(
      session$setInputs(sorting_confirm = 1))

  })

})

clean_all()
