# Batch script to ingest data to the Peskas infrastructure. See params.yaml for
# the list of datasets and the interfaces to obtain them. Authentication details
# (for example KOBO_HUMANITARIAN_TOKEN) need to be set up as environment
# variables in order for the script to connect to the appropiate services

# Read parameters
params <- yaml::read_yaml("params.yaml")

#

# Read datasets
datasets <- purrr::map(params$datasets, read_dataset)

