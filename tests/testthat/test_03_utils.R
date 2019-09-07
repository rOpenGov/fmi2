httptest::with_mock_api({

  test_that("FMI API variable descriptions work", {
    # Use min ground temperature (TG_PT12H_min) and average precipitation
    # (rrday) as examples

    # Sould return a tibble with certain dimensions
    desc <- describe_variable("TG_PT12H_min")
    expect_is(desc, "tbl")
    expect_equal(nrow(desc), 1)
    expect_equal(ncol(desc), 6)
    # Check that all variables (other than name) have values
    dat <- desc %>%
      dplyr::select(-variable) %>%
      dplyr::slice(1) %>%
      unlist(use.names = FALSE)
    expect_true(!all(is.na(dat)))

    # Should return 2 rows
    desc <- describe_variable(c("TG_PT12H_min", "rrday"))
    expect_equal(nrow(desc), 2)

    # Should cause an error
    expect_error(desc <- describe_variable("foobar"))
  })

  test_that("FMI API response is correctly transformed to a spatial object", {
    empty_obj <- NULL
    # Get a response object
    fmi_obj <- fmi_api(request = "getFeature",
                       storedquery_id = "fmi::observations::weather::daily::simple",
                       starttime = "2019-01-01", endtime = "2019-01-04",
                       fmisid = 100946)
    # to_sf() must return a sf object, but won't accept anything else but a
    # fmi_api object.
    expect_error(sf_object <- to_sf(empty_obj))
    expect_is(sf_object <- to_sf(fmi_obj), "sf")
  })
})
