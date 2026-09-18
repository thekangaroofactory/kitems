
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Create / update / delete attribute.

create_testdata()

# -- test
test_that("admin_server attribute_create works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(attribute_action = "foo-attribute_create"))

    # -- fill inputs
    session$setInputs(attribute_name = "bar")
    session$setInputs(attribute_desc = "test")
    session$setInputs(attribute_type = "numeric")
    session$setInputs(attribute_class_arg = NULL)
    session$setInputs(attribute_values_verb = NULL)
    session$setInputs(attribute_values = NULL)
    session$setInputs(attribute_default = NULL)
    session$setInputs(attribute_hide = TRUE)
    session$setInputs(attribute_skip = TRUE)
    session$setInputs(attribute_refresh = TRUE)

    # -- click
    expect_no_error(
      session$setInputs(w_confirm = 1))

  })

})

clean_all()
