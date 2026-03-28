# 1. Artifact Registry (Storage for Docker Images)
resource "google_artifact_registry_repository" "my_repo" {
  location      = var.region
  repository_id = "app-repo"
  description   = "Docker repository for metadata inspector"
  format        = "DOCKER"
}

# 2. Runtime Service Account (Application Identity)
resource "google_service_account" "sa_runtime" {
  account_id   = "sa-cloudrun-runtime"
  display_name = "Service Account for Cloud Run Runtime"
}

# 3. Secret Manager (Sensitive Configuration)
resource "google_secret_manager_secret" "app_secret" {
  secret_id = "app-metadata-config"
  replication {
    auto {}
  }
}

# 4. Create an initial version for the secret (Required for mounting)
resource "google_secret_manager_secret_version" "initial_version" {
  secret      = google_secret_manager_secret.app_secret.id
  secret_data = "initial-placeholder-value"
}

# 5. Grant Access: Allow SA-Runtime to read the secret
resource "google_secret_manager_secret_iam_member" "secret_access" {
  secret_id = google_secret_manager_secret.app_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.sa_runtime.email}" # Fixed prefix
}

# 6. Cloud Run Service (v2)
resource "google_cloud_run_v2_service" "app_service" {
  name     = "metadata-inspector-api"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.sa_runtime.email 
    
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" # Placeholder
      
      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }

      volume_mounts {
        name       = "secret-volume"
        mount_path = "/secrets"
      }
    }

    volumes {
      name = "secret-volume"
      secret {
        secret = google_secret_manager_secret.app_secret.secret_id
        items {
          version = "latest"
          path    = "config.txt"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
    ]
  }
}

# 7. Public Access (Unauthenticated)
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  name     = google_cloud_run_v2_service.app_service.name
  location = google_cloud_run_v2_service.app_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}