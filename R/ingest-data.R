#' Ingest data
#'
#' @param data_params List specifying parameters of data to be ingested
#' @param storage_params List specifying parameters of cloud storage
#'
#' @return TRUE if ingestion was successful
#' @export
#'
ingest_data <- function(data_params, storage_params){
  
  if (data_params$interface == "api"){
    retrieved_data <- request_through_api(data_params)
  } else {
    stop("cannot handle dataset class")
  }
  
  tempfile_path <- retrieved_to_tempfile(retrieved_data, data_params)
  write_data(tempfile_path, storage_params)
}

#' Save retrieved data into a temporary file
#'
#' @param retrieved_data Object containing the retrieved data as text
#' @param data_params List specifying parameter of ingested data
#'
#' @return Character string specifying the path where the retrieved data has
#'   been saved. `data_params` are added as an attribute
#' 
#' @export
#' 
retrieved_to_tempfile <- function(retrieved_data, data_params){
  
  if (!is.null(data_params$ingestion$name_append)){
    data_params$name <- paste0(data_params$name, '_', 
                               data_params$ingestion$name_append)
  }
  
  # Save the retrieved data into a temporary file
  file_name <- paste(data_params$name, 
                     data_params$data_format, sep = ".")
  dir_name <- tempdir()
  path <- file.path(dir_name, file_name)
  writeLines(text = retrieved_data, con = path)
  
  # Add data metadata to the path and return it
  attr(path, "metadata") <- data_params
  path
}
