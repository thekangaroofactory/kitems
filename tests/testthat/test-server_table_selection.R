

# -- Setup
create_testdata()


# -- Scenario:
test_that("[testServer] In table selection works", {

  # -- declare arguments
  params <- list(id = module_id,
                 path = testdata_path,
                 create = FALSE,
                 autosave = TRUE)

  # -- module server call
  testServer(kitems, args = params, {

    # -- flush reactive values
    session$flushReact()

    # -- update input
    session$setInputs(filtered_view_rows_selected = c(3,4))

    # -- check
    expect_equal(selected_items(), k_items()$id[1:2])

    # -- update input
    session$setInputs(filtered_view_cell_clicked = list(col = 3))

    # -- check
    expect_equal(clicked_column(), "Total")

  })

})


# -- Cleanup
clean_all()
