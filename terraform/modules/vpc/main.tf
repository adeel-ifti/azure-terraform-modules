
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "subnets" {
  for_each                 = { for a_subnet in var.subnets : a_subnet.subnet_name => a_subnet }
  project                  = var.project_id
  private_ip_google_access = var.private_ip_google_access
  network                  = google_compute_network.vpc.id
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.cidr
  region                   = each.value.region

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  depends_on = [
    google_compute_network.vpc
  ]

  #    dynamic "secondary_ip_range" {
  #     for_each = length(local.secondary_ip_ranges) > 0 ? local.secondary_ip_ranges : {}

  #     content {
  #       range_name    = secondary_ip_range.key
  #       ip_cidr_range = secondary_ip_range.value
  #     }
  #    }

  # ignore changes to the secondary_ip_range as it is maintained by the ITO team.
  lifecycle {
    ignore_changes = [
      secondary_ip_range,
    ]
  }
}
