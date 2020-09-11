read_dataset <- function(dataset){
  if (dataset$interface == "api"){
    response <- request_through_api(dataset)
  } else {
    stop("cannot handle dataset class")
  }
}


request_through_api <- function(dataset_info){
  
  # Eval all R expressions in the data set info recursively
  parsed_dataset <- rapply(dataset_info, eval_inline_r, how = "replace")
  # Select the fields that we'll use in the API request
  request_info <- parsed_dataset[c("url", "path", "query")]
  # Add headers in configuration if they exist
  if (!is.null(parsed_dataset$config)) {
    request_info$config <- 
      purrr::lift_dl(httr::add_headers)(parsed_dataset$config$headers)
  }
  # Request data
  response <- purrr::lift_dl(httr::GET)(request_info)
  process_response_status(response)
}

#' Evaluate inline R expression in a string
#'
#' Evaluates R expressions of the type `r foo()`
#'
#' @param x character
#'
#' @return If x is an R expression it returns the evaluated R expression,
#'   otherwise it returns x
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


process_response_status <- function(this_response){
  
  httr::warn_for_status(
    this_response, 
    paste(
      "download data from", 
      this_response$url))
  
  if(httr::http_error(this_response)) {
    handle_kobo_error() 
    return(NULL)
  } else{
    this_response
  }
}



handle_kobo_error <- function(){
  
}

