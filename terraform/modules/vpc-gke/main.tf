
resource "google_compute_network" "vpc" {

  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = var.auto_create_subnetworks
}


resource "google_compute_subnetwork" "subnet" {

  name                     = var.subnet_name
  project                  = var.project_id
  network                  = google_compute_network.vpc.name
  region                   = var.region
  ip_cidr_range            = var.ip_cidr_range
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod"
    ip_cidr_range = var.ip_pod_range
  }

  secondary_ip_range {
    range_name    = "k8s-svc"
    ip_cidr_range = var.ip_svc_range
  }
}



