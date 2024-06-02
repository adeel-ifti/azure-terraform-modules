

# Forward IPSec traffic coming into our static IP to our VPN gateway.
resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  region      = var.region
  project     = var.project_id
  ip_protocol = "ESP"
  ip_address  = var.vpn_gateway_ip_euw2
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
}

# The following two sets of forwarding rules are used as a part of the IPSec
# protocol
resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  region      = var.region
  project     = var.project_id
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = var.vpn_gateway_ip_euw2
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
}

# The following set of FW rule is for UDP 4500
resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  region      = var.region
  project     = var.project_id
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = var.vpn_gateway_ip_euw2
  target      = google_compute_vpn_gateway.vpn_gateway.self_link
}

// Setting up Routes
resource "google_compute_route" "vpn-route" {
  count               = length(var.remote_cidr)
  name                = "${var.vpn_tunnel_name}-route${count.index + 1}"
  project             = var.project_id
  network             = var.network_name
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel_rdc.self_link
  dest_range          = var.remote_cidr[count.index]
  priority            = var.route_priority
}