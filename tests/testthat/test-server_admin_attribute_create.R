
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Create attribute.

create_testdata()

# -- test
test_that("admin_server attribute_create works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(attribute_action = list(item = "foo", action = "create")))

    # -- fill inputs
    session$setInputs(attribute_name = "bar")
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
