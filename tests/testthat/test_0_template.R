

#----------------------------------
#  INIT
#----------------------------------

# # get tests path
# target_path <- file.path(system.file("tests", package = "kitems"), "testdata")
#
# # file
# target_file <- "test_dataset.csv"
#
# # data model
# colClasses <- c(id = "numeric", date = "POSIXct", name = "character", isvalid = "logical")
#
# # check
# if(file.exists(file.path(target_path, target_file))){
#
#   # delete a file
#   unlink(file.path(target_path, target_file))
#
#   # delete a directory -- must add recursive = TRUE
#   unlink(target_path, recursive = TRUE)
#
# }


#----------------------------------
#  TEST
#----------------------------------

# test_that("File creation", {
#
#   res <- loadItems(target_path, target_file, colClasses)
#
#   # is data.frame
#   expect_output(str(res), "data.frame")
#
#   # check dims
#   expect_equal(dim(res), c(0,4))
#
#   # check column types
#   expect_equal(colClasses, sapply(res, function(x) class(x)[[1]]))
#
# })

