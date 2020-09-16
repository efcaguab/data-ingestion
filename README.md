# Peskas - data ingestion

Peskas is an advanced intelligence platform for artisanal fisheries. To provide reports and actionable insights it uses data from multiple sources. 

Disaggregated fisheries data is confidential and securely held into Peskas data wharehouse. This repository contains:

* Code to securely ingest data into the Peskas data wharehouse. Composed primarily by a series of Google Storage Buckets (cloud based object storage).
* Scripts to deploy the ingestion code into serverless containers. The containers are built (and code executed) using Google Cloud Run. 

## Ingestion parameters

All the details needed to ingest data (ingestion parameters) are specified in [`params.yaml`](params.yaml). This file contains details about the datasets that should be ingested and the storage service where they're saved. 

Parameters can be dynamically evaluated using the inline R convention (`r foo()`) and support specifing parameters specifically for development or production environments. For example, with the following specification. The parameter "var" will take the "abc" value in development and "ABC" in production. 

```yaml
var: 
  dev: "abc"
  prod: "ABC"
```

Datasets fields:

Multiple datasets are allowed. Each of them should have the following fields:

* *interface*: The interface used to retrieve data. Supported values are:
    * *api*: Retrieves data using an HTTP GET RESTFUL request.
* *data_format*: The format of the retrieved data. Supported values are: 
    * *json* 
    * *csv* 
* *name*: Name of the data. This name will be used in the storage service. The file extension is inferred from the data_format
* Other fields depend on the interface used. For *api*, it requires url, path, and other GET request details. 

Storage fields:

Only one storage service is allowed. It should have the following fields:

* *provider*: The provider of the storage service. Supported values are: 
    * *google*: Saves data Google Cloud Storage Service
* Other fields dependning on the provider. For *google* it requires bucket and auth_file

##  Environment variables

The script requires the following environment variables to be configured:

Required:

* `ENV`: Specifies whether the code should be built in a development (`EVN=dev`) or production (`ENV=prod`) environment. 

Optional:

The following environment variables are only required if they are specified through the `params.yaml` file. 

* `KOBO_HUMANITARIAN_TOKEN`: Token to connect to the KOBO API. Required if retrieving data from the Kobo Humanitarian server.
* `GCS_AUTH_FILE`: Path to the Google Cloud Services .json authentication file. 

## Deployment

1. Ensure Storage API is enabled
2. Ensure Cloud Run API is enabled
3. Enable Secret Manager API
4. Create a Service Account for the data ingestion
5. Provide storage access to the service account
6. Provide secret access to the cloud run service account
7. Make sure the storage buckets needed exist

## Support & Contributing

For general questions about the Peskas Platform, contact [Alex Tilley](mailto:a.tilley@cgiar.org). For questions about Peskas' code and technical infrastructure, contact [Fernando Cagua](mailto:f.cagua@cgiar.org).

## Authors

**Fernando Cagua**

-   Website: <http://www.cagua.co/>
-   Github: <https://github.com/efcagua/>

**Alex Tilley**

- Email: [a.tilley@cgiar.org](mailto:a.tilley@cgiar.org)

## License

The code is available under the [MIT license](LICENSE).