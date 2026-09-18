
create_testdata()

legacy_dm <- data.frame(
  name = c("id", "date", "name", "quantity", "total", "isvalid"),
  type = c("numeric", "POSIXct", "character", "integer", "numeric", "logical"),
  default.val = c(NA, NA, "foo", 0, 0, TRUE),
  default.fun = c("ktools::getTimestamp", "Sys.time", NA, NA, NA, NA),
  default.arg = c("list(k = 1000)", NA, NA, NA, NA, NA),
  display = c(F, T, T, T, T, T),
  skip = c(T, F, F, F, F, F),
  sort.rank = c(NA, 1, NA, NA, NA, NA),
  sort.desc = c(NA, F, NA, NA, NA, NA))

attr(legacy_dm, "version") <- "0.7.3"


saveRDS(legacy_dm, file = file.path(testdata_path, "test_data_model.rds"))

# -- baseline: just launch the server
test_that("admin_server migration works", {

  # -- module server call
  testServer(admin_server, {

    # -- click
    expect_no_error(
      session$setInputs(migrate = 1))

  })

})

clean_all()
