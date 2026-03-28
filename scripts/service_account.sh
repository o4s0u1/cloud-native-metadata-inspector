#!/bin/bash
source ./env.sh

echo "--- Configuring Service Account: ${SA_NAME} ---"

# Create the Service Account
gcloud iam service-accounts create ${SA_NAME} \
    --display-name="Service Account for Terraform Deployer" || true

# Link SA with WIF (Allow GitHub to impersonate this SA)
gcloud iam service-accounts add-iam-policy-binding "${SA_EMAIL}" \
    --project="${PROJECT_ID}" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${WIF_POOL}/attribute.repository/${GITHUB_REPO}"

# List of Hardened Roles
ROLES=(
    "roles/run.admin"                # Manage Cloud Run services
    "roles/artifactregistry.repoAdmin" # Manage image repositories 
    "roles/secretmanager.admin" # Manage Secrets 
    "roles/resourcemanager.projectIamAdmin" # Required for Terraform to grant permissions to SA-Runtime
    "roles/iam.serviceAccountUser"   # Essential: Allows GitHub to "act as" the SA during deployment
)

for ROLE in "${ROLES[@]}"; do
  echo "Assigning Role: ${ROLE}"
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member="serviceAccount:${SA_EMAIL}" \
      --role="${ROLE}" --quiet
done