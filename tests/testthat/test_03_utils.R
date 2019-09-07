httptest::with_mock_api({

  test_that("FMI API response is correctly transformed to a spatial object", {
    empty_obj <- NULL
    # Get a response object
    fmi_obj <- fmi_api(request = "getFeature",
                       storedquery_id = "fmi::observations::weather::daily::timevaluepair",
                       starttime = "2019-01-01", endtime = "2019-01-04",
                       fmisid = 100946)
    # to_sf() must return a sf object, but won't accept anything else but a
    # fmi_api object.
    expect_error(sf_object <- to_sf(empty_obj))
    expect_is(sf_object <- to_sf(fmi_obj), "sf")
  })
})
