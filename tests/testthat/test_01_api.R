httptest::with_mock_api({

  test_that("FMI API object is correctly created", {
    expect_error(fmi_api(request = "foobar"),
                 "^Invalid request type")
    expect_is(fmi_api(request = "DescribeStoredQueries"), "fmi_api")
  })

  test_that("Non-existing path causes a well-behaving error", {
    # This should raise an error
    expect_error(fmi_api(request = "DescribeStoredQueries",
                         storedquery_id = "fmi::observations::weather::monthly::foobar"),
                 regexp = "^Invalid query ID")
  })

  #test_that("HTTP errors are dealt properly", {
  #  # NOTE: "suoritteet" is a valid resource name, BUT the mocked response
  #  # object is sourced from a manually edited file
  #  expect_error(vipunen_api(paste0(api_url, "/suoritteet")),
  #               "Vipunen API request failed")
  #})
})
