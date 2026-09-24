
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Move attribute.

create_testdata()

# -- test
test_that("admin_server attribute_move works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(attribute_action = list(item = "foo", action = "move", id = "total")))

    # -- fill inputs
    session$setInputs(attribute_move_position = "before")
    session$setInputs(attribute_move_target = "date")

    # -- click
    expect_no_error(
      session$setInputs(attribute_move_confirm = 1))

  })

})

clean_all()
