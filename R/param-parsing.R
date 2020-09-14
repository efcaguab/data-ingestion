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


#' Select variables based on the environment (dev/prod/...)
#'
#' Given a list, keep only the values for the specified environment.
#'
#' @param x a list (possibly of parameters)
#' @param env a character with the environment to keep. If an empty string,
#'   nothing is done
#'
#' @return a list with only the values for the specified environment
#' @export
#'
#' @examples
#' x <- list(var = list(dev = "abc", prod = "ABC"))
#' parse_environment(x, "dev")
parse_environment <- function(x, env = Sys.getenv("ENV")){
  
  assertthat::assert_that(is.character(env))
  
  # Keep only the item with the name y
  chuck_name <- function(x, y){
    if(any(y %in% names(x))){
      purrr::chuck(x, y)
    } else {
      x
    }
  }
  
  # If the environment is an empty string (for example when the environment
  # variable has not been specified), return the same object
  if (env == ""){
    return(x)
  }
  
  # First if there are dev and prod at the base level
  xx <- chuck_name(x, env)
  
  # Because the list can be nested we need to iterate across different levels.
  # We start from the deepest level and work the way backwards to the root (0)
  for (i in -purrr::vec_depth(xx):0){
    xx <- purrr::modify_depth(xx, i, chuck_name, y = env)
  }
  xx
}
