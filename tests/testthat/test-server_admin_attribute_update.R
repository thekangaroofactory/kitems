
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
      session$setInputs(attribute_action = list(item = "foo", action = "update", id = "total")))

    # -- fill inputs
    session$setInputs(attribute_name = "total")
    session$setInputs(attribute_desc = "test")
    session$setInputs(attribute_type = "numeric")
    session$setInputs(attribute_class_arg = "")
    session$setInputs(attribute_values_verb = "any")
    session$setInputs(attribute_values = "")
    session$setInputs(attribute_default = "")
    session$setInputs(attribute_hide = TRUE)
    session$setInputs(attribute_skip = TRUE)
    session$setInputs(attribute_refresh = TRUE)

    # -- click
    expect_no_error(
      session$setInputs(w_confirm = 1))

  })

})

clean_all()
