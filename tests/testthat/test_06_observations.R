test_that("obs_weather_daily() arguments are handled correctly", {
  # Use Hanko Tulliniemi weather station
  hanko_id <- 100946

  ## Check arguments
  # At least one location argument must be provided
  expect_error(obs_weather_daily(starttime = "2019-01-01",
                                 endtime = "2019-01-04"),
               "No location argument provided")
  # Start and end times must be dates or strings that can be coerced into
  # dates
  expect_error(obs_weather_daily(starttime = "foo",
                                 endtime = "2020-01-04",
                                 fmisid = hanko_id))
  # Start and end times must be in the past
})

httptest2::with_mock_api({

  test_that("daily observation data for a weather station are retrieved correctly", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946
    obs_dat <- obs_weather_daily(starttime = "2019-01-01",
                                 endtime = "2019-01-04",
                                 fmisid = hanko_id)

    expect_is(obs_dat, "sf")
    expect_identical(names(obs_dat), c("time", "variable", "value", "Location"))
    expect_is(obs_dat$time, "Date")
    expect_is(obs_dat$variable, "character")
    expect_is(obs_dat$value, "numeric")
    expect_is(obs_dat$Location, "sfc")
  })

  test_that("hourly observation data for a weather station are retrieved correctly", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946

    obs_dat <- obs_weather_hourly(starttime = "2019-01-01",
                                  endtime = "2019-01-02",
                                  fmisid = hanko_id)

    expect_is(obs_dat, "sf")
    expect_identical(names(obs_dat), c("time", "variable", "value", "Location"))
    expect_is(obs_dat$time, "POSIXct")
    expect_is(obs_dat$variable, "character")
    expect_is(obs_dat$value, "numeric")
    expect_is(obs_dat$Location, "sfc")
  })

  test_that("monthly observation data for a weather station are retrieved correctly", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946

    obs_dat <- obs_weather_monthly(starttime = "2019-01-01",
                                  endtime = "2019-01-02",
                                  fmisid = hanko_id)

    expect_is(obs_dat, "sf")
    expect_identical(names(obs_dat), c("time", "variable", "value", "Location"))
    expect_is(obs_dat$time, "Date")
    expect_is(obs_dat$variable, "character")
    expect_is(obs_dat$value, "numeric")
    expect_is(obs_dat$Location, "sfc")
  })

  test_that("hourly air quality observation data for a weather station are retrieved correctly", {
    # Use Helsinki Kallio 2 weather station
    kallio_id <- 100662

    obs_dat <- get_airquality(starttime = "2019-01-01",
                                   endtime = "2019-01-02",
                                   fmisid = kallio_id)

    expect_is(obs_dat, "sf")
    expect_identical(names(obs_dat), c("time", "variable", "value", "Location"))
    expect_is(obs_dat$time, "POSIXct")
    expect_is(obs_dat$variable, "character")
    expect_is(obs_dat$value, "numeric")
    expect_is(obs_dat$Location, "sfc")
  })

})
