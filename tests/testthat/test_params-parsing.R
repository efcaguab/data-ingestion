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
