testthat::context("parameter parsing works")

test_that("inline R is evaluated when needed", {
  expect_equal(eval_inline_r("`r 1+1`"), "2")
  expect_equal(eval_inline_r("1+1"), "1+1")
  expect_equal(eval_inline_r(""), "")
})

test_that("missing is missing", {
  expect_equal(eval_inline_r(NA), NA)
})

test_that("parse vectors", {
  x <- c("abc", "`r paste(letters[1:3], collapse = '')`")
  expect_equal(eval_inline_r(x), c("abc", "abc"))
})

test_that("environment parsing works in simple case", {
  x <- list(var = list(dev = "abc", prod = "ABC"))
  expect_equal(parse_environment(x, "dev")$var, "abc")
})

test_that("environment parsing works at base level", {
  x <- list(dev = "abc", prod = "ABC")
  expect_equal(parse_environment(x, "dev"), "abc")
  x <- list(dev = list(a = 1, b = 2), prod = list(a = 3, b = 4))
  expect_identical(parse_environment(x, "dev"), list(a = 1, b = 2))
})

test_that("it works even if some of the params are unnamed", {
  x <- list(dev = "abc", "ABC")
  expect_equal(parse_environment(x, "dev"), "abc")
})

test_that("environment parsing does nothing with empty string", {
  x <- list(var = list(dev = "abc", prod = "ABC"))
  expect_identical(parse_environment(x, ""), x)
})
