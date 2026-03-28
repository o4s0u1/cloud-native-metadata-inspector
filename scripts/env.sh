#!/bin/bash

# Project Information
export PROJECT_ID="cloud-metadata-inspector"
export LOCATION="asia-southeast1"
export GITHUB_REPO="o4s0u1/cloud-native-metadata-inspector"

# Service Account & WIF Details
export SA_NAME="sa-terraform-deployer"
export SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
export WIF_POOL="github-pool"
export WIF_PROVIDER="github-provider"

# Fetch Project Number automatically
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")