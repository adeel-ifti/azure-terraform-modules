
output "network" {
  value = google_compute_network.vpc.name
}

output "subnetwork" {
  value = google_compute_subnetwork.subnet.name
}

output "ip_range_pod_name" {
  value = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
}

output "ip_range_svc_name" {
  value = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name
}