test_that("downloading works", {
  # First, time should download the data
  expect_message(stations <- fmi_stations(), "Station list downloaded")
  # If done again immediately, should use cached version
  expect_message(stations <- fmi_stations(), "Using cached stations")
})
