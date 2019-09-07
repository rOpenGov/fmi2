httptest::with_mock_api({

  test_that("daily observation data for a weather station are retrieved correctly", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946
    # Instantaneous Weather Observations (fmi::observations::weather::simple)
    obs_dat <- obs_weather_daily(starttime = "2019-01-01",
                                 endtime = "2019-01-04",
                                 fmisid = hanko_id)
    expect_is(obs_dat, "sf")
    expect_identical(names(obs_dat), c("time", "variable", "value", "geometry"))
    expect_is(obs_dat$time, "Date")
    expect_is(obs_dat$variable, "character")
    expect_is(obs_dat$value, "numeric")
    expect_is(obs_dat$geometry, "sfc")
  })

})
