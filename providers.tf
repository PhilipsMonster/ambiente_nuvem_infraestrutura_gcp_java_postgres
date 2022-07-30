# Configura o Provider Google Cloud com o Projeto
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.27.0"
    }
  }
}

# Configura o Provider Google Cloud com o Projeto
provider "google" {

  project = "minha_organizacao"
  region  = "us-west1"
  zone    = "us-west1-b"
}

provider "google-beta" {
  project = "minha_organizacao"
  region  = "us-west1"
  zone    = "us-west1-b"
}