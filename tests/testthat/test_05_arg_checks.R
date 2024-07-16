test_that("arguments for weather observations are checked", {

  ## FMISID
  # Valid
  expect_true(valid_fmisid(101976))
  # Fail
  expect_false(valid_fmisid(NULL))
  expect_false(valid_fmisid(-9999))

  ## place
  # Valid
  expect_true(valid_place("Turku"))
  # Fail
  expect_false(valid_place(NULL))
  expect_false(valid_place("test"))

  ## geoid
  # Valid
  expect_true(valid_geoid(-16000130))
  # Fail
  expect_false(valid_geoid(0))
  expect_false(valid_geoid(9999))

  ## wmo
  # Valid
  expect_true(valid_wmo(2998))
  # Fail
  expect_false(valid_wmo(-9999))
  expect_false(valid_wmo(0))

  ## timestep
  # Valid
  expect_true(valid_timestep(120))
  # Fail
  expect_false(suppressMessages(valid_timestep("test")))
  expect_false(suppressMessages(valid_timestep(-120)))

  ## bbox
  # Valid
  expect_true(valid_bbox(c(22, 64, 24, 68)))
  # Fail
  expect_false(valid_bbox(c(1,1,1,1)))
  expect_false(valid_bbox(c(-99, -99, -99, -99)))
})
