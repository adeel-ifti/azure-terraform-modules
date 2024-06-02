
provider "google" {
  project = "gcp-bigdata-demo-1"
}

provider "google-beta" {
  project = "gcp-bigdata-demo-1"
}
data "google_client_config" "default" {
  provider = google-beta
}

# terraform {
# backend "gcs" {
#   bucket = "terraform-state-gcp-001"
#   prefix = "terraform-state-01"
# }
# }


