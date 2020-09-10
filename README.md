# Peskas - data ingestion

Peskas is an advanced intelligence platform for artisanal fisheries. To provide reports and actionable insights it uses data from multiple sources. 

Disaggregated fisheries data is confidential and securely held into Peskas data wharehouse. This repository contains:

* Code to securely ingest data into the Peskas data wharehouse. Composed primarily by a series of Google Storage Buckets (cloud based object storage) and BigQuery tables (databases optimised for analytics).
* Scripts to deploy the ingestion code into serverless containers. The containers are built (and code executed) using Google Cloud Run. 

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