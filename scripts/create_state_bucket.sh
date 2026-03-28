#!/bin/bash
source ./env.sh

BUCKET_NAME="terraform-state-${PROJECT_ID}"

echo "--- Creating GCS Bucket for Terraform State ---"
gcloud storage buckets create gs://${BUCKET_NAME} \
    --location="${LOCATION}" \
    --uniform-bucket-level-access || echo "Bucket already exists."

echo "--- Granting Bucket Access to SA-Terraform ---"
gcloud storage buckets add-iam-policy-binding gs://${BUCKET_NAME} \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="roles/storage.objectAdmin"