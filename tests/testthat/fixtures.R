library(fmi2)
library(httptest2)
library(httr2)

.mockPaths("tests/testthat")


# Observation variable descriptions ----------------------------------------

desc_url_1 <- "https://opendata.fmi.fi/meta?observableProperty=observation&param=TG_PT12H_min&language=eng"
desc_url_2 <- "https://opendata.fmi.fi/meta?observableProperty=observation&param=TG_PT12H_min,rrday&language=eng"

httptest2::start_capturing()

httr2::request(des_url_1) %>%
  httr2::req_perform()
httr2::request(desc_url_2) %>%
  httr2::req_perform(desc_url_2)

httptest2::stop_capturing()

# Daily weather observations ----------------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::observations::weather::daily::simple",
                   starttime = "2019-01-01", endtime = "2019-01-04",
                   fmisid = 100946)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(dat_obj) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Hourly weather observations ---------------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::observations::weather::hourly::simple",
                   starttime = "2019-01-01", endtime = "2019-01-02",
                   fmisid = 100946)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(dat_obj$url) %>%
  httr2::req_perform()

httptest2::stop_capturing()

# FMI stations ------------------------------------------------------------

dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::ef::stations")

httptest2::start_capturing()

httr2::request(dat_obj$url) %>%
  req_perform()

httptest2::stop_capturing()
