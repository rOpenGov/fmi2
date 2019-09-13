test_that("downloading works", {
  # Check for faulty url. NOTE: this needs to be done first because of the
  # closure's caching
  expect_error(stations <- fmi_stations(url = "http://en.ilmatieteenlaitos.fi/foobar"))
  # First, time should download the data
  expect_message(stations <- fmi_stations(), "Station list downloaded")
  # If done again immediately, should use cached version
  expect_message(stations <- fmi_stations(), "Using cached stations")
  # Check the returned data
  expect_is(stations, "tbl")

  # A dummy call to cover the whole closure. Normally the closure is evaluated
  # when the package is loaded, but covr will miss parts of the closure if
  # this is not done.
  fmi2:::.fmi_stations_closure()
})


