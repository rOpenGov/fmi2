httptest::with_mock_api({

  test_that("FMI API object is correctly created", {
    expect_error(fmi_api(request = "foobar"),
                 "^Invalid request type")
    expect_is(fmi_api(request = "DescribeStoredQueries"), "fmi_api")
  })

  test_that("Non-existing path causes a well-behaving error", {
    # This should raise an error
    expect_error(fmi_api(request = "getFeature",
                         storedquery_id = "fmi::observations::weather::monthly::foobar",
                         starttime = "2019-01-01", endtime = "2019-01-02"),
                 regexp = "^FMI API request failed")
  })

  test_that("Redundant arguments cause a warning", {
    # This should raise a warning, storedquery_id is ignored if
    # request = "DescribeStoredQueries"
    expect_warning(fmi_api(request = "DescribeStoredQueries",
                           storedquery_id = "fmi::observations::weather::monthly::weather"),
                 regexp = "^storedquery_id ignored")
  })

  #test_that("HTTP errors are dealt properly", {
  #  # NOTE: "suoritteet" is a valid resource name, BUT the mocked response
  #  # object is sourced from a manually edited file
  #  expect_error(vipunen_api(paste0(api_url, "/suoritteet")),
  #               "Vipunen API request failed")
  #})
})
