output "bt_instance_display_name" {
  description = "Display name for bigtable instance"
  value       = google_bigtable_instance.bt_instance.*.display_name
}

output "bt_instance_id" {
  description = "Bigtalbe instance id"
  value       = google_bigtable_instance.bt_instance.*.id
}