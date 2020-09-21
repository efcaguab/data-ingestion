#' List files in storage
#'
#' @param storage_params List specifying parameters of cloud storage 
#'
#' @return A data frame with the objects in the default bucket
#' @export
#' 
list_files_storage <- function(storage_params){
  if(storage_params$provider == "google"){
    list_files_google(storage_params)
  }
}

#' Write data into cloud storage service
#'
#' @param data_path Character string. Path of the file to be written.
#'   `data_params` must be specified in the "metadata" attribute
#' @param ... Not implemented
#'
#' @export
#'
write_data <- function(data_path, ...){
  
  dataset_params <- attr(data_path, "metadata", exact = TRUE)
  storage_params <- dataset_params$storage
  
  if (storage_params$provider == "google") {
    write_dataset_google(data_path, storage_params, ...)
  } else {
    stop("cannot handle storage for this provider")
  }
}

#' Write data into Google Cloud Storage
#'
#' @param data_path Character string. Path of the file to be written.
#'   `data_params` must be specified in the "metadata" attribute
#' @param storage_params List specifying parameters of cloud storage 
#' @param ... Not implemented
#'
#' @return
#' @export
#'
#' @examples
write_dataset_google <- function(data_path, storage_params, ...){
  
  dataset_attributes <- attr(data_path, "metadata", exact = TRUE)
  set_up_google_authentication(storage_params)
  
  googleCloudStorageR::gcs_upload(file = data_path, 
                                  bucket = storage_params$bucket, 
                                  name = basename(data_path),
                                  predefinedAcl = "default")
}

#' List files in Google Cloud storage
#'
#' @param storage_params List specifying parameters of cloud storage 
#'
#' @return A data frame with the objects in the default bucket
#' @export
#'
list_files_google <- function(storage_params){
  set_up_google_authentication(storage_params)
  googleCloudStorageR::gcs_list_objects(bucket = storage_params$bucket)
}

#' Authenticate to Google Cloud Storage
#'
#' @param storage_params List specifying parameters of cloud storage 
#'
#' @export
#'
set_up_google_authentication <- function(storage_params){
  googleCloudStorageR::gcs_auth(here::here(storage_params$auth_file))
}
