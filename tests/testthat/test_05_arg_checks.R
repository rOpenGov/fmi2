test_that("arguments for weather observations are checked", {

  ## FMISID
  # Valid
  expect_true(valid_fmisid(101520))
  # Fail
  expect_false(valid_fmisid(NULL))
  expect_false(valid_fmisid(-9999))
})
