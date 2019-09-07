httptest::with_mock_api({

  test_that("data for a weather station are retrieved correctly", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946
    # Instantaneous Weather Observations (fmi::observations::weather::simple)
    obs_dat <- obs_weather(starttime = "2019-01-01", endtime = "2019-01-02",
                           fmisid = hanko_id)
  })

})
