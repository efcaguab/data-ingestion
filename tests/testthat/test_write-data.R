testthat::context("storage service works as expected")

test_that("google authentication file exists where expected", {
  skip_if(Sys.getenv('GCS_AUTH_FILE') == "")
  expect_true(file.exists(here::here(Sys.getenv('GCS_AUTH_FILE'))))
})

test_that("able to upload and delete files to Google Cloud", {
  # only test if there is network
  skip_if_offline()
  # only test if the Google Auth file Environment Variable is present
  skip_if(Sys.getenv('GCS_AUTH_FILE') == "")
  # only test if the file is there
  skip_if_not(file.exists(here::here(Sys.getenv('GCS_AUTH_FILE'))))
  
  # Create storage parameters
  storage_params <- list(auth_file = Sys.getenv('GCS_AUTH_FILE'), 
                         bucket = "peskas-storage-dev")
  
  # Create dummy file for testing
  file_name <- paste(tempfile(), "txt", sep = ".")
  writeLines(paste("testing connection to Google Cloud Storage", 
                   Sys.time()), 
             con = file_name)
  
  # Upload file to Google Cloud Storage and test it was successful
  response <- write_dataset_google(file_name, storage_params)
  expect_equal(file.size(file_name), as.numeric(response$size))
  
  # Delete object from Google cloud
  deletion_successful <- googleCloudStorageR::gcs_delete_object(
    object_name = basename(file_name), 
    bucket = storage_params$bucket
  )
  expect_true(deletion_successful)
  
})