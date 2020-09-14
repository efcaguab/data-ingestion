download_dataset <- function(dataset_params){
  
  # Eval all R expressions in the data set parameters recursively
  parsed_dataset_params <- rapply(object = dataset_params, 
                                  f = eval_inline_r, 
                                  how = "replace")
  
  if (parsed_dataset_params$interface == "api"){
    retrieved_data <- request_through_api(parsed_dataset_params)
  } else {
    stop("cannot handle dataset class")
  }
  
  # Save the retrieved data into a temporary file
  file_name <- paste(parsed_dataset_params$name, 
                     parsed_dataset_params$data_format, sep = ".")
  dir_name <- tempdir()
  path <- file.path(dir_name, file_name)
  writeLines(text = retrieved_data, con = path)
  
  # Add data metadata to the path and return it
  attr(path, "metadata") <- dataset_params
  path
}


request_through_api <- function(dataset_info){
  
  # Select the fields that we'll use in the API request
  request_info <- dataset_info[c("url", "path", "query")]
  
  # Add headers in configuration if they exist
  if (!is.null(dataset_info$config)) {
    request_info$config <- 
      purrr::lift_dl(httr::add_headers)(dataset_info$config$headers)
  }
  
  # Request data
  response <- purrr::lift_dl(httr::GET)(request_info)
  process_response_status(response)
  httr::content(response, as = "text", encoding = dataset_info$encoding)
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
