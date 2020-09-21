# Batch script to ingest data to the Peskas infrastructure. See "params.yaml"
# for the list of data sets and the interfaces to obtain them. 

# Read R functions
purrr::walk(list.files("R", full.names = TRUE), source)

# Read and parse parameters
params <- yaml::read_yaml(here::here("params.yaml")) 
params <- parse_environment(params, Sys.getenv("ENV"))
params <- parse_r(params)

# DAILY UPDATE ------------------------------------------------------------

purrr::walk(.x = params$datasets, .f = ingest_data)

# HISTORICAL DATA ---------------------------------------------------------

# If the daily ingestion is only for new data, then a series of historical data
# sets must be available as well. The following section connects to the storage
# bucket and identifies the datasets than need to be downloaded to complete the
# historical record

# Identify data sets where only new data is retrieved daily
historical_datasets <- purrr::keep(params$datasets,
                                   ~ .$ingestion$type == "new-data")

# Given a historical dataset ingest previous updates that are not yet downloaded
download_historical_dataset <- function(dataset_params) {

  storage_params <- dataset_params$storage
  
  # Identify all previous updates 
  hist_dates <- seq(from = as.Date(dataset_params$ingestion$start_date), 
                    to = Sys.Date()-1, by = 1)
  hist_names <- paste0(dataset_params$name, "_", hist_dates)
  hist_file_names <- paste0(hist_names, ".", dataset_params$data_format)
  
  # Determine data that should be downloaded
  existing_files <- list_files_storage(storage_params)$name
  dates_to_download <- hist_dates[!hist_file_names %in% existing_files]
  
  if (length(dates_to_download) > 0) {
    # Create new data_params for the historical data
    hist_params <- purrr::map(.x = dates_to_download, 
                              .f = create_new_date_params_pelagic, 
                              data_params = dataset_params)
    
    purrr::walk(.x = hist_params, .f = ingest_data)
  }
}

# Download historical data if needed 
purrr::walk(.x = historical_datasets, .f = download_historical_dataset)
