
# Attach a VPN gateway to a network.
resource "google_compute_vpn_gateway" "vpn_gateway" {
  name        = var.vpn_name
  network     = var.network_name
  region      = var.region
  project     = var.project_id
  description = var.vpn_description
}

# Each tunnel is responsible for encrypting and decrypting traffic exiting
# and leaving its associated gateway
resource "google_compute_vpn_tunnel" "vpn_tunnel_rdc" {
  name                    = var.vpn_tunnel_name
  region                  = var.region
  project                 = var.project_id
  peer_ip                 = var.remote_gateway_ip
  shared_secret           = var.shared_message
  target_vpn_gateway      = google_compute_vpn_gateway.vpn_gateway.self_link
  local_traffic_selector  = var.local_cidr
  remote_traffic_selector = var.remote_cidr

  depends_on = [google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
    google_compute_forwarding_rule.fr_esp,
  ]
}