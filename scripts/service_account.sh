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
    "roles/run.admin"                        # Full control over Cloud Run services
    "roles/artifactregistry.repoAdmin"       # Manage Artifact Registry repositories and images
    "roles/secretmanager.admin"              # Manage secrets and their versions in Secret Manager
    "roles/resourcemanager.projectIamAdmin"  # Required for Terraform to manage IAM policies (e.g., for SA-Runtime)
    "roles/iam.serviceAccountUser"           # Essential: Allows GitHub Actions to "act as" this Service Account
    "roles/storage.admin"                    # Full control over GCS (Required for Terraform state and image layers)
)

for ROLE in "${ROLES[@]}"; do
  echo "Assigning Role: ${ROLE}"
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member="serviceAccount:${SA_EMAIL}" \
      --role="${ROLE}" --quiet
done