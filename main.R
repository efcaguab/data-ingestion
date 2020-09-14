# Batch script to ingest data to the Peskas infrastructure. See "params.yaml"
# for the list of data sets and the interfaces to obtain them. 

# Read R functions
purrr::walk(list.files("R", full.names = TRUE), source)

# Read parameters
params <- yaml::read_yaml(here::here("params.yaml")) 
params <- parse_environment(params, Sys.getenv("ENVIRONMENT"))

# Read datasets
dataset_paths <- purrr::map(params$datasets, download_dataset)

# Save datasets
purrr::map(dataset_paths, write_dataset, storage_params)
