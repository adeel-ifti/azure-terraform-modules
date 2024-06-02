
resource "google_redis_instance" "memstore" {

  project                 = var.project
  name                    = var.name
  tier                    = var.tier
  region                  = var.region
  location_id             = var.location_id
  alternative_location_id = var.alternative_location_id

  memory_size_gb          = var.memory_size_gb
  connect_mode            = var.connect_mode
  auth_enabled            = var.auth_enabled
  transit_encryption_mode = var.transit_encryption_mode
  authorized_network      = var.authorized_network

  redis_version     = var.redis_version
  redis_configs     = var.redis_configs
  display_name      = var.display_name
  reserved_ip_range = var.reserved_ip_range
  labels = var.labels

}
