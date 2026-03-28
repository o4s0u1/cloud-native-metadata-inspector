variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "cloud-metadata-inspector"
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "asia-southeast1"
}