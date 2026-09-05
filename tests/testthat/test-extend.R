

test_that("Verb extend works", {

  # -- single instruction
  x <- design(project = "test",
              item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "date", type = "Date", default = "Sys.Date()"))

  expect_identical(c_items(x), "foo")
  expect_identical(c_attributes(x, "foo"), c("id", "date"))

  # -- multiple instructions
  x <- design(project = "test",
              item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "date", type = "Date", default = "Sys.Date()"),
           attribute = c(name = "comment", type = "character"))
  expect_identical(c_items(x), "foo")
  expect_identical(c_attributes(x, "foo"), c("id", "date", "comment"))

  # -- dummy instruction
  x <- design(project = "test",
              item = "foo") |>
    extend(item = "foo",
           attribute = c(name = "date", type = "Date", default = "Sys.Date()"),
           dream = "draw me a sheep",
           attribute = c(name = "comment", type = "character"))
  expect_identical(c_items(x), "foo")
  expect_identical(c_attributes(x, "foo"), c("id", "date", "comment"))

})

clean_all()
