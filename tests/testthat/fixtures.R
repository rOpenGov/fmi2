library(httptest)
library(httr)

.mockPaths("tests/testthat")

httptest::start_capturing()

# NOTE: this is not the most elegant use of the namespace, but since it's not
# exported...
httr::GET(fmi2:::fmi2_global$saved_queries_url)

httptest::stop_capturing()
