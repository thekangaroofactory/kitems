

test_that("admin layouts works", {

  x <- admin_attribute_card(attribute = list(name = "id"), item = "foo")
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

  x <- admin_attribute_modal()
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

  x <- admin_item_card(name = "foo")
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

  x <- admin_item_dz(name = "foo")
  expect_type(x, "list")

  x <- admin_item_layout(c_extract(config, item = "foo"))
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

  x <- admin_no_yaml_layout()
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

  x <- admin_yaml_message(config)
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

  x <- admin_migration_required_layout(list("foo", "bar"))
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")

  x <- admin_migration_done_layout(path = ".")
  expect_type(x, "list")
  expect_identical(attributes(x)$class, "shiny.tag")


  x <- admin_attribute_nb(config)
  expect_type(x, "character")




})
