#!/bin/bash
PROJECT_ID="peskas"
TRIGGER_ID="584c3699-9f73-4955-990f-055448968cc6"
BRANCH_NAME="master"

echo {"branchName": "${BRANCH_NAME}"}

# Run the ingestion script once a day at midnight (UTC)
gcloud scheduler jobs create http ${PROJECT_ID}-daily-run \
    --schedule='0 0 * * *' \
    --uri=https://cloudbuild.googleapis.com/v1/projects/${PROJECT_ID}/triggers/${TRIGGER_ID}:run \
    --message-body='{"branchName": "master"}' \
    --oauth-service-account-email=${PROJECT_ID}@appspot.gserviceaccount.com \
    --oauth-token-scope=https://www.googleapis.com/auth/cloud-platform
