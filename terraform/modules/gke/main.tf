
data "google_compute_zones" "available" {
  provider = google-beta

  project = var.project_id
  region  = var.region
}

locals {
  cluster_id      = google_container_cluster.gke_cluster.id
  node_pool_names = [for np in toset(var.node_pools) : np.name]
  node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))

  location = var.regional ? var.region : var.zones[0]
}

data "google_container_engine_versions" "region" {
  location = local.location
  project  = var.project_id
}

data "google_container_engine_versions" "zone" {
  location = local.location
  project  = var.project_id
}
