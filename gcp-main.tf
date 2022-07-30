# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "spotmusic-repo-back" {
  provider = google-beta

  location = "us-central1"
  repository_id = "spotmusic-back"
  description = "Imagens Docker to SpotMusic BackEnd"
  format = "DOCKER"
}

resource "google_artifact_registry_repository" "spotmusic-repo-front" {
  provider = google-beta

  location = "us-central1"
  repository_id = "spotmusic-front"
  description = "Imagens Docker to SpotMusic FrontEnd"
  format = "DOCKER"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${local.env}-${local.project}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      dynamic "authorized_networks" {
        for_each = local.authorized_networks
        content {
          name  = lookup(authorized_networks.value, "name", null)
          value = authorized_networks.value.value
        }
      }

      ipv4_enabled    = true
      private_network = google_compute_network.vpc.id
    }
  }
  deletion_protection = "false"
}

resource "google_sql_database" "db" {
  name      = "citizix"
  instance  = local.sql_instance_name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "user" {
  name     = "root"
  instance = local.sql_instance_name
  host     = "%"
  password = ""
}

output "postgres_instance_name" {
  description = "The name of the postgres database instance"
  value       = google_sql_database_instance.postgres.name
}

output "postgres_public_ip_address" {
  description = "The public IPv4 address of the postgres instance."
  value       = google_sql_database_instance.postgres.public_ip_address
}

output "postgres_private_ip_address" {
  description = "The public IPv4 address of the postgres instance."
  value       = google_sql_database_instance.postgres.private_ip_address
}