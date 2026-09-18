

# -- baseline: just launch the server
test_that("admin_server works", {

  # -- module server call
  expect_no_error(
    testServer(admin_server, {}))

})

