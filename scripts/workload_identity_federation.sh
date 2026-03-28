#!/bin/bash
source ./env.sh

echo "--- Configuring Workload Identity Federation ---"

# Create WIF Pool
gcloud iam workload-identity-pools create "${WIF_POOL}" \
    --location="global" \
    --display-name="GitHub Pool" || true

# Create OIDC Provider for GitHub
gcloud iam workload-identity-pools providers create-oidc "${WIF_PROVIDER}" \
    --location="global" \
    --workload-identity-pool="${WIF_POOL}" \
    --display-name="GitHub Provider" \
    --issuer-uri="https://token.actions.githubusercontent.com" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
    --attribute-condition="assertion.repository == '$GITHUB_REPO'" || true