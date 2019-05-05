library(dplyr)

httptest::with_mock_api({

  test_that("stored queries data is retrieved correcly", {
    # Internal function, not exported
    sq <- fmi2:::.get_stored_queries()
    expect_is(sq, "xml_nodeset")
  })

  test_that("stored queries data is parsed correctly", {
    sq <- list_queries()
    # The repsponse is XML that needs to be parsed into a tibble with three
    # columns
    expect_equal(ncol(sq), 4)
    # Listing all availble queries should have more rows
    sq_all <- list_queries(all = TRUE)
    expect_true(nrow(sq_all) > nrow(sq))
  })

  test_that("stored queries parameter data is parsed correctly", {

    # This should work
    id <- "fmi::observations::weather::daily::timevaluepair"
    param_data <- list_parameters(id)
    expect_is(param_data, "tbl_df")

    # Check the number of parameters
    param_no <- list_queries(all = TRUE) %>%
      dplyr::filter(query_id == id) %>%
      dplyr::pull(no_parameters)
    expect_equal(nrow(param_data), param_no)
  })

  #test_that("vipunen_api object prints", {
  #  expect_output(print(vipunen_api(api_url)))
  #})


})
