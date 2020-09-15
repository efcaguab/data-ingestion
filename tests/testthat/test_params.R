testthat::context("params.yaml is structured correctly")

params <- yaml::read_yaml(here::here("params.yaml"))

# Formats and providers for which there is current support
valid_interfaces <- c("api")
valid_formats <- c("json", "csv")
valid_providers <- c("google")
valid_environments <- c("dev")

test_that("parameter has datasets fields",{
  expect_true("datasets" %in% names(params))
})

test_that("all datasets have name field", {
  expect_true(
    all(
      purrr::map_lgl(
        params$datasets, 
        ~ "name" %in% names(.))))
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

test_that("api datasets have valid url", {
  api_datasets <- purrr::keep(params$datasets, ~ .$interface == "api")
  expect_true(
    all(
      purrr::map_lgl(
        api_datasets, 
        ~ "url" %in% names(.)
      )
    )
  )
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

test_that("environment is valid", {
  skip_if(Sys.getenv('ENV') == "")
  expect_true(
    Sys.getenv('ENV') %in% valid_environments
  )
})

test_that("storage provider is valid", {
  expect_true(
    params$storage$provider %in% valid_providers
  )
})