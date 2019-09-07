library(fmi2)
library(httptest)
library(httr)

.mockPaths("tests/testthat")


# Observation variable descriptions ----------------------------------------

desc_url_1 <- "https://opendata.fmi.fi/meta?observableProperty=observation&param=TG_PT12H_min&language=eng"
desc_url_2 <- "https://opendata.fmi.fi/meta?observableProperty=observation&param=TG_PT12H_min,rrday&language=eng"

httptest::start_capturing()

httr::GET(desc_url_1)
httr::GET(desc_url_2)

httptest::stop_capturing()

# Daily weather observations ----------------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::observations::weather::daily::simple",
                   starttime = "2019-01-01", endtime = "2019-01-04",
                   fmisid = 100946)

httptest::start_capturing()

httr::GET(dsq_obj$url)
httr::GET(dat_obj$url)

httptest::stop_capturing()


# Hourly weather observations ---------------------------------------------

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::observations::weather::hourly::simple",
                   starttime = "2019-01-01", endtime = "2019-01-02",
                   fmisid = 100946)

httptest::start_capturing()

httr::GET(dsq_obj$url)
httr::GET(dat_obj$url)

httptest::stop_capturing()

