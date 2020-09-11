library(testthat)

purrr::walk(list.files("R", full.names = TRUE), source)

test_dir(here::here("tests/testthat/"))
