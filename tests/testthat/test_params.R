testthat::context("params.yaml is structured correctly")

test_that("parameter has datasets fields",{
  expect_true("datasets" %in% names(yaml::read_yaml(here::here("params.yaml"))))
})
