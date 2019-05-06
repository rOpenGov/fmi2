library(fmi2)
library(httptest)
library(httr)

.mockPaths("tests/testthat")

dsq_obj <- fmi_api("DescribeStoredQueries")

httptest::start_capturing()

httr::GET(dsq_obj$url)

httptest::stop_capturing()
