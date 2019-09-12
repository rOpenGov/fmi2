test_that("downloading works", {
  # First, time should download the data
  expect_message(stations <- fmi_stations(), "Station list downloaded")
  # If done again immediately, should use cached version
  expect_message(stations <- fmi_stations(), "Using cached stations")

  expect_is(stations, "tbl")

  # A dummy call to cover the whole closure. Normally the closure is evaluated
  # when the package is loaded, but covr will miss parts of the closure if
  # this is not done.
  fmi2:::.fmi_stations_closure()

})
