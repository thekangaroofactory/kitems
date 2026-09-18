
# //////////////////////////////////////////////////////////////////////////////
# Use case:
# Attribute wizard (we just go through the steps).

create_testdata()

# -- test
test_that("admin_server attribute wizard works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(attribute_action = "foo-attribute_create_x"))

    # -- invalid values
    session$setInputs(attribute_name = "")
    session$setInputs(attribute_name = "id")
    session$setInputs(attribute_name = "foo bar")
    session$setInputs(attribute_name = "dum?!my")

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
      session$setInputs(w_next = 1))

    # -- fill inputs
    session$setInputs(attribute_allow_class_arg = TRUE)
    session$setInputs(attribute_allow_class_arg = FALSE)

    # -- click
    expect_no_error(
      session$setInputs(w_next = 2))

    # -- fill inputs
    session$setInputs(attribute_values_verb = TRUE)
    session$setInputs(attribute_values_verb = FALSE)

    # -- click
    expect_no_error(
      session$setInputs(w_next = 3))

    # -- click
    expect_no_error(
      session$setInputs(w_next = 4))

    # -- fill inputs
    session$setInputs(attribute_skip = TRUE)
    session$setInputs(attribute_skip = FALSE)

    # -- click
    expect_no_error(
      session$setInputs(w_next = 5))

  })

})

clean_all()
