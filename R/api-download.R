#' Request data through API request
#' 
#' @param data_params List specifing parameters of data to be ingested 
#'
#' @return Object containing the retrieved data as text
#' @export
#'
request_through_api <- function(data_params){
  
  # Select the fields that we'll use in the API request
  request_info <- data_params[c("url", "path", "query")]
  
  # Add headers in configuration if they exist
  if (!is.null(data_params$config)) {
    request_info$config <- 
      purrr::lift_dl(httr::add_headers)(data_params$config$headers)
  }
  
  # Request data
  response <- purrr::lift_dl(httr::GET)(request_info)
  process_response_status(response)
  httr::content(response, as = "text", encoding = data_params$encoding)
}

#' Process side effects of response
#'
#' @param this_response an httr::GET response
#'
process_response_status <- function(this_response){
  
  httr::warn_for_status(
    this_response, 
    paste(
      "download data from", 
      this_response$url))
  
  if(httr::http_error(this_response)) {
    handle_api_error() 
    return(NULL)
  } else{
    this_response
  }
}

#' Actions taken if API response is erroneous
#'
#' @export
#'
handle_api_error <- function(){
  
}
