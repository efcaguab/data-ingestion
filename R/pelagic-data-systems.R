#' Update a pelagic datasystems data_params to get data from a specific date
#'
#' Updates the path of the api request (where dates for the data download are
#' specified) and the `name_append` which contains the date to be appended in
#' the file name
#' 
#' @param new_date Date to update params
#' @param data_params List specifying parameters of data to be ingested
#'
#' @return List with updated fields
#' @export
#'
create_new_date_params_pelagic <- function(new_date, data_params){
  data_params$path[5] <- as.character(new_date -1)
  data_params$path[6] <- as.character(new_date)
  data_params$ingestion$name_append <- as.character(new_date)
  data_params
}
