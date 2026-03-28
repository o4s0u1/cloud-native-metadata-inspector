#!/bin/bash
source ./env.sh

BUCKET_NAME="terraform-state-${PROJECT_ID}"

echo "--- Creating GCS Bucket for Terraform State ---"
# Create the bucket with uniform access control
gcloud storage buckets create gs://${BUCKET_NAME} \
    --location="${LOCATION}" \
    --uniform-bucket-level-access || echo "Bucket already exists."