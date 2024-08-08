httptest2::with_mock_api({

  test_that("add_station function works", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946
    obs_dat <- obs_weather_daily(starttime = "2019-01-01",
                                 endtime = "2019-01-04",
                                 fmisid = hanko_id)
    obs_dat<- add_station(obs_dat)
    expect_identical(names(obs_dat), c("time", "variable", "value", "station_name", "fmisid",
                                       "Location"))
    expect_false(is.null(obs_dat$station_name))
    expect_false(is.null(obs_dat$fmisid))
  })


  test_that("label_variables function works", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946
    obs_dat <- obs_weather_daily(starttime = "2019-01-01",
                                 endtime = "2019-01-04",
                                 fmisid = hanko_id)
    # With no replacement
    obs_dat_no_rep<- label_variables(obs_dat)
    expect_identical(names(obs_dat_no_rep), c("time", "variable", "value", "label", "Location"))
    expect_false(is.null(obs_dat_no_rep$label))
    # With replacement
    obs_dat_rep <- label_variables(obs_dat, replace = TRUE)
    expect_identical(names(obs_dat_rep), c("time", "value", "variable", "Location"))
    expect_false(is.null(obs_dat_rep$variable))
  })


  test_that("cite_fmi2 function works", {
    # Use Hanko Tulliniemi weather station
    hanko_id <- 100946
    obs_dat <- obs_weather_daily(starttime = "2019-01-01",
                                 endtime = "2019-01-04",
                                 fmisid = hanko_id)
    # Biblatex
    expect_output(ym <- cite_fmi2(obs_dat, format = "Biblatex"))
    expect_output(cite_fmi2(obs_dat, format = "Biblatex", printCitation = FALSE), regexp = NA)
    expect_equal(class(ym), "Bibtex")
    expect_equal(length(ym), 9)
    # bibentry
    expect_output(ym <- cite_fmi2(obs_dat, format = "bibentry"))
    expect_output(cite_fmi2(obs_dat, format = "bibentry", printCitation = FALSE), regexp = NA)
    expect_equal(class(ym)[1], "BibEntry")
    expect_equal(length(ym), 1)
    # Bibtex
    expect_output(ym <- cite_fmi2(obs_dat, format = "Bibtex"))
    expect_output(cite_fmi2(obs_dat, format = "Bibtex", printCitation = FALSE), regexp = NA)
    expect_equal(class(ym), "Bibtex")
    expect_equal(length(ym), 9)
  })

})
