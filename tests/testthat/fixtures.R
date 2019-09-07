library(fmi2)
library(httptest)
library(httr)

.mockPaths("tests/testthat")

dsq_obj <- fmi_api("DescribeStoredQueries")
dat_obj <- fmi_api(request = "getFeature",
                   storedquery_id = "fmi::observations::weather::daily::simple",
                   starttime = "2019-01-01", endtime = "2019-01-04",
                   fmisid = 100946)

httptest::start_capturing()

httr::GET(dsq_obj$url)
httr::GET(dat_obj$url)

httptest::stop_capturing()
