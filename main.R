# Read authentication and parameters
auth <- yaml::read_yaml("auth.yaml")
vars <- yaml::read_yaml("vars.yaml")

# INGEST KOBO DATASETS ----------------------------------------------------

kobo_datasets <- purrr::keep(vars$datasets, ~ .$source_type == "kobo")
purrr::map(kobo_datasets, ~ read_kobo_data(.$url, .$path, auth$kobo$token))

