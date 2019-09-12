library(dplyr)
library(fmi2)



test_that("downloading works", {
  # First, time should download the data
  expect_message(stations <- fmi_stations(), "Station list downloaded")
  # If done again immediately, should use cached version
  expect_message(stations <- fmi_stations(), "Using cached stations")
})

test_that("local version is up-to-date", {
  local_stations <- fmi2:::.fmi_stations_local()
  downloaded_stations <- fmi_stations()

  # for some reason this fails with tibbles, so convert to regular data.frames
  #downloaded_stations <- as.data.frame(downloaded_stations)
  #local_stations <- as.data.frame(local_stations)

  expect_equivalent(local_stations, downloaded_stations, info = paste0(
    "The observation station list on the FMI website has been updated, ",
    "and the local copy needs to be updated with:\n",
    'write.csv(fmi_stations(), file="inst/extdata/fmi_stations.csv", row.names=FALSE)'))
})
