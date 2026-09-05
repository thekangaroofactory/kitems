

test_that("attribute_values works", {

  # -- unit test
  helper <- function(values){

    expect_no_error(x <- attribute_values(values = values, data.model = dm))
    expect_s3_class(x, "data.frame")

    # -- check output class vs dm
    if(ncol(x) > 0)
      expect_true(class(x[[1, 1]])[1] == dm[dm$name == colnames(x), ]$type)

  }

  # -- integer
  helper(values = c(quantity = NA))
  helper(values = c(quantity = NULL))
  helper(values = c(quantity = integer(0)))
  helper(values = c(quantity = 0))
  helper(values = c(quantity = round(runif(1, 1, 100), digits = 0)))
  helper(values = c(quantity = runif(1, 1, 100)))
  helper(values = c(quantity = "12"))

  # -- numeric
  helper(values = c(total = NA))
  helper(values = c(total = NULL))
  helper(values = c(total = numeric(0)))
  helper(values = c(total = runif(1, 1, 100)))
  helper(values = c(total = round(runif(1, 1, 100), digits = 0)))
  helper(values = c(total = "12.5"))

  # -- character
  helper(values = c(name = NA))
  helper(values = c(name = NULL))
  helper(values = c(name = character(0)))
  helper(values = c(name = paste0(letters[round(runif(5, 1, 26), digits = 0)], collapse = "")))
  helper(values = c(name = 12.5))

  # -- Date
  helper(values = c(date = NA))
  helper(values = c(date = NULL))
  helper(values = c(date = Sys.Date()))
  helper(values = c(date = Sys.time()))
  helper(values = c(date = "2025/12/25"))

  # -- POSIXct
  helper(values = c(created = NA))
  helper(values = c(created = NULL))
  helper(values = c(created = Sys.Date()))
  helper(values = c(created = Sys.time()))
  helper(values = c(created = "2025/12/25"))

  # -- logical
  helper(values = c(isvalid = NA))
  helper(values = c(isvalid = NULL))
  helper(values = c(isvalid = logical(0)))
  helper(values = c(isvalid = TRUE))
  helper(values = c(isvalid = FALSE))

})
