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
  expect_true(valid_place(c("Turku", "Helsinki")))
  # Fail
  expect_false(valid_place(NULL))
  expect_false(valid_place("test"))
  expect_false(valid_place(c("Helsinki", "test")))

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

  ## time arguments
  # Valid
  expect_true(valid_time("2024-01-01", "2024-01-07"))
  # Fail
  expect_false(valid_time("01-01-2024", "07-01-2024"))
  expect_false(valid_time("2024-01-07", "2024-01-01"))

  ## bbox
  # Valid
  expect_true(valid_bbox(c(22, 64, 24, 68)))
  expect_true(valid_bbox("22,64,24,68"))
  # Fail
  expect_false(valid_bbox(c(1,1,1,1)))
  expect_false(valid_bbox("1,1,1,1"))
  expect_false(valid_bbox(c(-99, -99, -99, -99)))

  ## crs
  # Valid
  expect_true(valid_crs("4258"))
  # Fail
  expect_false(valid_crs("0000"))
})
