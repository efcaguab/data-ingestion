#!/bin/bash
PROJECT_ID="peskas"
BUCKET_NAME="timor"
TOPIC_NAME="timor-raw-storage-update"
SUBSCRIPTION=""

# Create topics (can be done through the Gcloud console)
gcloud pubsub topics create ${TOPIC_NAME} \
    --project=${PROJECT_ID}
# Setup notifications from the buckets
gsutil notification create -t ${TOPIC_NAME} -f json gs://${BUCKET_NAME}
