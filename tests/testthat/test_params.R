testthat::context("params.yaml is structured correctly")

params <- yaml::read_yaml(here::here("params.yaml"))
valid_interfaces <- c("api")
valid_formats <- c("json", "csv")

test_that("parameter has datasets fields",{
  expect_true("datasets" %in% names(params))
})

test_that("all datasets have interface field", {
  expect_false(
    any(
      purrr::map_lgl(
        params$datasets, 
        ~ is.null(.$interface))))
})

test_that("dataset interfaces are valid", {
  expect_true(
    all(
      purrr::map_lgl(
        params$datasets, 
        ~ .$interface %in% valid_interfaces)))
})

test_that("all datasets have data format field", {
  expect_false(
    any(
      purrr::map_lgl(
        params$datasets, 
        ~ is.null(.$data_format))))
})

test_that("dataset formats are valid", {
  expect_true(
    all(
      purrr::map_lgl(
        params$datasets, 
        ~ .$data_format %in% valid_formats)))
})
