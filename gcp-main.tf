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

resource "google_vpc_access_connector" "vpc_seara" {
  provider      = google-beta
  name          = "vpc-seara"
  subnet {
    name = google_compute_subnetwork.custom_test.name
  }
  machine_type = "e2-micro"
}

resource "google_compute_subnetwork" "custom_test" {
  provider      = google-beta
  name          = "vpc-con"
  ip_cidr_range = "10.2.0.0/28"
  region        = "us-central1"
  network       = google_compute_network.custom_test.id
}

resource "google_compute_network" "seara" {
  provider                = google-beta
  name                    = "vpc-seara"
  auto_create_subnetworks = false
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name             = "searaembu"
  region           = "us-central1"
  database_version = "POSTGRES_14"

  depends_on = [google_vpc_access_connector.vpc_seara]

  settings {
    tier = "db-f1-micro"    
  }
}