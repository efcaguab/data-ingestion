write_dataset <- function(this_dataset, storage_params, ...){
  
  dataset_params <- attr(this_dataset, "metadata", exact = TRUE)
  
  # Eval all R expressions in the data set parameters recursively
  parsed_storage_params <- rapply(object = storage_params, 
                                  f = eval_inline_r, 
                                  how = "replace")
  
  if (storage_params$provider == "google") {
    write_dataset_google(this_dataset, parsed_storage_params, ...)
  } else {
    stop("cannot handle storage for this provider")
  }
  
}

write_dataset_google <- function(this_dataset, storage_params, ...){
  
  dataset_attributes <- attr(this_dataset, "metadata", exact = TRUE)
  set_up_google_authentication(storage_params)
  
  googleCloudStorageR::gcs_upload(file = this_dataset, 
                                  bucket = storage_params$bucket, 
                                  name = basename(this_dataset))

}

set_up_google_authentication <- function(storage_params){
  googleCloudStorageR::gcs_auth(here::here(storage_params$auth_file))
}