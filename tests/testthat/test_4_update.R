

#----------------------------------
#  INIT
#----------------------------------

# get tests path
target_path <- file.path(system.file("tests", package = "kitems"), "testdata")

# file
target_file <- "test_dataset.csv"

# data model
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")

# # UPDATE ITEM
item <- list(id = 1, date = as.POSIXct(x = 1200, origin = "01/01/1970"), name = "update1", isvalid = TRUE)


#----------------------------------
#  TEST
#----------------------------------

test_that("Update", {

  res <- loadItems(target_path, target_file, colClasses)
  res <- updateItem(res, item, target_path, target_file)

  # is data.frame
  expect_output(str(res), "data.frame")

  # check dims
  expect_equal(dim(res), c(2,4))

  # check value
  expect_match(res[1, ]$name, "update1")

})


