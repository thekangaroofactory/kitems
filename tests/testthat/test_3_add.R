

#----------------------------------
#  INIT
#----------------------------------

# get tests path
target_path <- file.path(system.file("tests", package = "kitems"), "testdata")

# file
target_file <- "test_dataset.csv"

# data model
colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")

# items
item1 <- list(id = 1, date = as.POSIXct(x = 1200, origin = "01/01/1970"), name = "name1", isvalid = TRUE)
item2 <- list(id = 2, date = as.POSIXct(x = 15000, origin = "01/01/1970"), name = "name2", isvalid = FALSE)


#----------------------------------
#  TEST
#----------------------------------

test_that("File creation", {

  res <- loadItems(target_path, target_file, colClasses)
  res <- addItem(res, items = item1, path = target_path, file = target_file, sort = NULL)
  res <- addItem(res, items = item2, path = target_path, file = target_file, sort = NULL)

  # is data.frame
  expect_output(str(res), "data.frame")

  # check dims
  expect_equal(dim(res), c(2,4))

})


