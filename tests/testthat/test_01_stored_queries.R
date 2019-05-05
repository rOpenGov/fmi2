httptest::with_mock_api({

  test_that("stored queries data is parsed correctly", {
    sq <- list_queries()
    # The repsponse is XML that needs to be parsed into a tibble with three
    # columns
    expect_equal(ncol(sq), 4)
    # Listing all availble queries should have more rows
    sq_all <- list_queries(all = TRUE)
    expect_true(nrow(sq_all) > nrow(sq))
  })



})
