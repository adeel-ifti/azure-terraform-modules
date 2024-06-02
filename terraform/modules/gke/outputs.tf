output "cluster_id" {
  description = "Cluster ID"
  value       = google_container_cluster.gke_cluster.id
}

output "name" {
  description = "Cluster name"
  value       = google_container_cluster.gke_cluster.name
}

output "release_channel" {
  description = "The release channel of this cluster"
  value       = var.release_channel
}



