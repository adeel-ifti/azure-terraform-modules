
locals {

  autoscaling_resource_limits = var.cluster_autoscaling.enabled ? concat([{
    resource_type = "cpu"
    minimum       = var.cluster_autoscaling.min_cpu_cores
    maximum       = var.cluster_autoscaling.max_cpu_cores
    }, {
    resource_type = "memory"
    minimum       = var.cluster_autoscaling.min_memory_gb
    maximum       = var.cluster_autoscaling.max_memory_gb
  }], var.cluster_autoscaling.gpu_resources) : []

  node_pools_oauth_scopes = merge(
    { all = ["https://www.googleapis.com/auth/cloud-platform"] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_oauth_scopes
  )

}
resource "google_container_cluster" "gke_cluster" {
  provider                 = google-beta
  name                     = var.name
  description              = var.description
  location                 = local.location
  project                  = var.project_id
  network                  = "projects/${var.project_id}/global/networks/${var.network}"
  subnetwork               = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"
  initial_node_count       = var.initial_node_count
  remove_default_node_pool = var.remove_default_node_pool
  networking_mode          = "VPC_NATIVE"

  release_channel {
    channel = var.release_channel != null ? var.release_channel : "UNSPECIFIED"
  }
  network_policy {
    enabled = var.network_policy_enabled
  }

  confidential_nodes {
    enabled = var.confidential_nodes
  }

  pod_security_policy_config {
    enabled = var.pod_security_policy_config
  }

  cluster_autoscaling {
    enabled = var.cluster_autoscaling.enabled
    dynamic "auto_provisioning_defaults" {
      for_each = var.cluster_autoscaling.enabled ? [1] : []

      content {
        service_account = local.service_account
        oauth_scopes    = local.node_pools_oauth_scopes["all"]
      }
    }
    autoscaling_profile = var.cluster_autoscaling.autoscaling_profile != null ? var.cluster_autoscaling.autoscaling_profile : "BALANCED"
    dynamic "resource_limits" {
      for_each = local.autoscaling_resource_limits
      content {
        resource_type = lookup(resource_limits.value, "resource_type")
        minimum       = lookup(resource_limits.value, "minimum")
        maximum       = lookup(resource_limits.value, "maximum")
      }
    }
  }

  default_max_pods_per_node = var.default_max_pods_per_node

  enable_shielded_nodes = var.shielded_nodes

  enable_binary_authorization = var.binary_authorization

  enable_kubernetes_alpha = var.kubernetes_alpha

  enable_intranode_visibility = var.intranode_visibility

  enable_tpu = var.tpu

  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling
  }

  addons_config {
    http_load_balancing {
      disabled = ! var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = ! var.horizontal_pod_autoscaling
    }

    istio_config {
      disabled = ! var.istio
      auth     = var.istio_auth
    }
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  lifecycle {
    ignore_changes = [node_pool, initial_node_count, node_config]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}


resource "google_container_node_pool" "gke_cluster_nodepool" {
  provider           = google-beta
  for_each           = local.node_pools
  name               = each.key
  project            = var.project_id
  location           = local.location
  cluster            = google_container_cluster.gke_cluster.name
  initial_node_count = var.initial_node_count

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count", 1)
      max_node_count = lookup(autoscaling.value, "max_count", 100)
    }
  }

  node_config {
    image_type       = "COS"
    machine_type     = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform = lookup(var.node_pools[0], "min_cpu_platform", "")
    local_ssd_count  = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb     = lookup(each.value, "disk_size_gb", 100)
    disk_type        = lookup(each.value, "disk_type", "pd-standard")

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[each.value["name"]],
    )
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}