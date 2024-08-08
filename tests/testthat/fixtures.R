library(fmi2)
library(httptest2)
library(httr2, warn.conflicts = FALSE)

.mockPaths("tests/testthat")


# Observation variable descriptions ----------------------------------------

desc_url_1 <- "https://opendata.fmi.fi/meta?observableProperty=observation&param=TG_PT12H_min&language=eng"
desc_url_2 <- "https://opendata.fmi.fi/meta?observableProperty=observation&param=TG_PT12H_min,rrday&language=eng"

httptest2::start_capturing()

httr2::request(desc_url_1) %>%
  httr2::req_perform()
httr2::request(desc_url_2) %>%
  httr2::req_perform()

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


# Monthly weather observations ---------------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::observations::weather::monthly::simple",
                   starttime = "2019-01-01", endtime = "2019-05-01",
                   fmisid = 100946)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(dat_obj$url) %>%
  httr2::req_perform()

httptest2::stop_capturing()

# Hourly air quality observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "urban::observations::airquality::hourly::simple",
                   starttime = "2019-01-01", endtime = "2019-01-05",
                   fmisid = 100662)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(dat_obj$url) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Hourly wind observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- get_wind(starttime = "2019-01-01", endtime = "2019-01-05", fmisid = 100949)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(attr(dat_obj, "url")) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Hourly temperature observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- get_temperature(interval = "hourly",
                           starttime = "2019-01-01", endtime = "2019-01-02", fmisid = 100949)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(attr(dat_obj, "url")) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Daily temperature observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- get_temperature(interval = "daily",
                           starttime = "2019-01-01", endtime = "2019-01-05", fmisid = 100949)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(attr(dat_obj, "url")) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Monthly temperature observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- get_temperature(interval = "monthly",
                           starttime = "2019-01-01", endtime = "2019-05-01", fmisid = 100949)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(attr(dat_obj, "url")) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Hourly precipitation observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- get_precipitation(interval = "hourly",
                           starttime = "2019-01-01", endtime = "2019-01-02", fmisid = 100949)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(attr(dat_obj, "url")) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Daily precipitation observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- get_precipitation(interval = "daily",
                           starttime = "2019-01-01", endtime = "2019-01-05", fmisid = 100949)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(attr(dat_obj, "url")) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# Monthly precipitation observations -----------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- get_precipitation(interval = "monthly",
                           starttime = "2019-01-01", endtime = "2019-05-01", fmisid = 100949)

httptest2::start_capturing()

httr2::request(dsq_obj$url) %>%
  httr2::req_perform()
httr2::request(attr(dat_obj, "url")) %>%
  httr2::req_perform()

httptest2::stop_capturing()


# FMI stations ------------------------------------------------------------

dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::ef::stations")

httptest2::start_capturing()

httr2::request(dat_obj$url) %>%
  req_perform()

httptest2::stop_capturing()
