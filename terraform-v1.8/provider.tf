
provider "google" {
}

provider "google-beta" {
}
data "google_client_config" "default" {
  provider = google-beta
}

terraform {
  backend "gcs" {
    bucket = "tfstate-001"
    prefix = "tfstate"
  }
}


