output "repository_name" {
  description = "The name of the Artifact Registry repository"
  value       = google_artifact_registry_repository.my_repo.name
}

output "runtime_sa_email" {
  description = "The email of the Runtime Service Account"
  value       = google_service_account.sa_runtime.email
}

output "service_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.app_service.uri
}