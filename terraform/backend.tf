terraform {
  # Remote backend to store state files securely in GCS
  backend "gcs" {
    bucket = "terraform-state-cloud-metadata-inspector"
    prefix = "terraform/state"
  }
}