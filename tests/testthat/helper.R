library(httptest2)
library(httr2, warn.conflicts = FALSE)

if (Sys.getenv("MOCK_BYPASS") == "true") {
  with_mock_api <- force
} else if (Sys.getenv("MOCK_BYPASS") == "capture") {
  with_mock_api <- capture_requests
}
