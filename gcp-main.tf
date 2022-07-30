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

resource "google_vpc_access_connector" "connector" {
  name          = "vpcconn"
  region        = "us-central1"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name             = "searaembudb"
  region           = "us-central1"
  database_version = "POSTGRES_14"

  depends_on = [google_vpc_access_connector.connector]

  settings {
    tier = "db-f1-micro"    
  }
}