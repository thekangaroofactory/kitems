
create_folder()

test_that("Skip grammar works", {

   # baseline
   config <- design(project = "test", item = "foo") |>
     extend(item = "foo", attribute = c(name = "date", type = "Date"))

   # skip attribute
   expect_no_warning(x <- config |>
                       skip(item = "foo", "date"))

   # get skipped attributes
   expect_identical(x |>
                      skipped(item = "foo"), "date")

   # include attribute
   expect_no_warning(x <- config |>
                       include(item = "foo", "date"))

   # get included attributes
   expect_identical(x |>
                      included(item = "foo"), c("id", "date"))

})

clean_all()
