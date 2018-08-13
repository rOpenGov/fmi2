library(dplyr)
library(fmi)
context("FMI station list")

test_that("downloading works", {
  expect_message(stations <- fmi_stations(), "Station list downloaded")
})

test_that("local version is up-to-date", {
  local_stations <- fmi:::.fmi_stations_local()
  downloaded_stations <- fmi_stations()

  # for some reason this fails with tibbles, so convert to regular data.frames
  downloaded_stations <- as.data.frame(downloaded_stations)
  local_stations <- as.data.frame(local_stations)

  expect_equal(local_stations, downloaded_stations, info = paste0(
    "The observation station list on the FMI website has been updated, ",
    "and the local copy needs to be updated with:\n",
    'write.csv(fmi_stations(), file="inst/extdata/fmi_stations.csv", row.names=FALSE)'))
})
