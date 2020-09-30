# Helps define the environment variables when running the code in a development
# environment

Sys.setenv(
  GCS_AUTH_FILE = "auth/data-ingestion-secret.json", 
  ENV = "prod", 
  KOBO_TOKEN_FILE = "auth/kobo-token.txt",
  PELAGIC_SECRET_FILE = "auth/pelagic-secret.yaml"
)
