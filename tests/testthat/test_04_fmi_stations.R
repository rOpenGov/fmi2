httptest::with_mock_api({

  test_that("FMI stations are retrieved correctly", {
    stat_dat <- fmi_stations()

    expect_is(stat_dat, "tbl")
    #expect_identical(names(obs_dat), c("time", "variable", "value", "geometry"))
    #expect_is(obs_dat$time, "Date")
    #expect_is(obs_dat$variable, "character")
    #expect_is(obs_dat$value, "numeric")
    #expect_is(obs_dat$geometry, "sfc")
  })
})
