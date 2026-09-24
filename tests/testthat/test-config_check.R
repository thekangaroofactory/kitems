

create_testdata()

test_that("config_check works", {

  # -- secure
  expect_error(config_check(NULL))

  # ////////////////////////////////////////////////////////////////////////////
  # config

  # -- extra element at root level
  config_2 <- config
  config_2$dummy <- 1
  x <- config_check(config_2)
  expect_length(x, 1)
  expect_identical(x[[1]]$code, 1)

  # -- version != package version
  config_2 <- config
  config_2$version <- "0"
  x <- config_check(config_2)
  expect_length(x, 1)
  expect_identical(x[[1]]$code, 2)

  # -- no item
  config_2 <- config
  config_2$items <- list()
  x <- config_check(config_2)
  expect_length(x, 1)
  expect_identical(x[[1]]$code, 3)

  # ////////////////////////////////////////////////////////////////////////////
  # item

  # -- no id
  config_2 <- config
  config_2$items[[1]]$id <- NULL
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 4)

  # -- wrong id
  config_2 <- config
  config_2$items[[1]]$id <- 1
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 5)

  # -- no source
  config_2 <- config
  config_2$items[[1]]$source <- NULL
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 6)

  # -- no source type
  config_2 <- config
  config_2$items[[1]]$source$type <- NULL
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 7)

  # -- no item file
  config_2 <- config
  config_2$items[[1]]$source$filename <- "dummy"
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 8)

  # -- no data.model
  config_2 <- config
  config_2$items[[1]]$data.model <- NULL
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 9)

  # -- no attribute
  config_2 <- config
  config_2$items[[1]]$data.model <- list()
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 10)

  # -- no id attribute
  config_2 <- config
  config_2$items[[1]]$data.model$attributes[[1]]$name <- "dummy"
  config_2$items[[1]]$data.model$skip <- NULL
  config_2$items[[1]]$data.model$hide <- NULL
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 11)

  # -- unknown skip
  config_2 <- config
  config_2$items[[1]]$data.model$skip <- c("id", "dummy")
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 12)

  # -- refresh not skip
  config_2 <- config
  config_2$items[[1]]$data.model$refresh <- c("dummy")
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 13)

  # -- unknown hidden
  config_2 <- config
  config_2$items[[1]]$data.model$hide <- c("dummy")
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 14)


  # ////////////////////////////////////////////////////////////////////////////
  # attribute

  # -- missing name
  config_2 <- config
  config_2$items[[1]]$data.model$attributes[[2]]$name <- NULL
  config_2$items[[1]]$data.model$attributes[[2]]$type <- "integer"
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 15)

  # -- invalid name
  config_2 <- config
  config_2$items[[1]]$data.model$attributes[[2]]$name <- 123
  config_2$items[[1]]$data.model$attributes[[2]]$type <- "integer"
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 16)

  # -- missing type
  config_2 <- config
  config_2$items[[1]]$data.model$attributes[[2]]$name <- "dummy"
  config_2$items[[1]]$data.model$attributes[[2]]$type <- NULL
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 17)

  # -- invalid type
  config_2 <- config
  config_2$items[[1]]$data.model$attributes[[2]]$name <- "dummy"
  config_2$items[[1]]$data.model$attributes[[2]]$type <- "dummy"
  x <- config_check(config_2)
  expect_identical(x[[1]]$code, 18)

})

clean_all()
