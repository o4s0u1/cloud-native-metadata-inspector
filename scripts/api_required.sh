#!/bin/bash
source ./env.sh

echo "--- Enabling Required APIs ---"
gcloud services enable \
    iam.googleapis.com \
    cloudresourcemanager.googleapis.com \
    sts.googleapis.com \
    iamcredentials.googleapis.com \
    artifactregistry.googleapis.com \
    run.googleapis.com \
    secretmanager.googleapis.com