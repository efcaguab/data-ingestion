#' Evaluate inline R expression in a string
#'
#' Evaluates R expressions of the type `r foo()`
#'
#' @param x character
#'
#' @return If x is an R expression it returns the evaluated R expression,
#'   otherwise it returns x as a character
#' @export
#'
#' @examples
#' eval_inline_r("`r 5+5`")
eval_inline_r <- function(x){
  # an R expression is like `r foo()`
  pattern <- "^`r (.+)`$"
  # x can be a vector so we use a for loop
  for (i in 1:length(x)){
    if (grepl(pattern = pattern, x[i])){
      x_expression <- parse(text = gsub(pattern, "\\1", x[i]))
      x[i] <- eval(x_expression)
    } 
  }
  x
}