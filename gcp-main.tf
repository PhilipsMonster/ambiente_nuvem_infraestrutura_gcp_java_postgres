# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "seara-repo-back" {
  provider = google-beta

  location = "us-central1"
  repository_id = "spotmusic-back"
  description = "Imagens Docker to Seara BackEnd"
  format = "DOCKER"
}

resource "google_artifact_registry_repository" "seara-repo-front" {
  provider = google-beta

  location = "us-central1"
  repository_id = "spotmusic-front"
  description = "Imagens Docker to Seara FrontEnd"
  format = "DOCKER"
}