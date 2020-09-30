library(googleCloudStorageR)
library(dplyr)

orig_bucket <- "pelagic-data-systems"
dest_bucket <- "pelagic-data-systems-raw"

gcs_auth(Sys.getenv("GCS_AUTH_FILE"))

if (FALSE){
  dest_objects <- gcs_list_objects(bucket = dest_bucket)
  if (nrow(dest_objects) > 0){
    purrr::walk(.x = dest_objects$name, 
                .f = ~ gcs_delete_object(object_name = ., bucket = dest_bucket))
  }
}

orig_objects <- gcs_list_objects(bucket = orig_bucket)
dest_objects <- gcs_list_objects(bucket = dest_bucket)

if (nrow(dest_objects) > 0){
  to_copy_objects <-
    dplyr::full_join(orig_objects, dest_objects, by = c("name", "size")) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::starts_with("updated")), as.POSIXct) %>%
    dplyr::filter(is.na(updated.y) | updated.x > updated.y)
} else {
  to_copy_objects <- orig_objects
}

slow_copy <- function(..., delay = 1){
  googleCloudStorageR::gcs_copy_object(...)
  Sys.sleep(delay)
}

purrr::walk(
  .x = to_copy_objects$name, 
  .f = ~ slow_copy(
    source_object = ., 
    destination_object = .,
    source_bucket = orig_bucket, 
    destination_bucket = dest_bucket, 
    destinationPredefinedAcl = "bucketownerfullcontrol"
  )
)