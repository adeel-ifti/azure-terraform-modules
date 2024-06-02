
output "vpn_gateway" {
  value = google_compute_vpn_gateway.vpn_gateway.name
}

output "vpn_gateway_id" {
  value = google_compute_vpn_gateway.vpn_gateway.id
}

output "vpn_gateway_tunnel1_address" {
  value = google_compute_vpn_tunnel.vpn_tunnel_rdc.self_link
}

output "vpn_gateway_tunnel1_remote_peer_ip" {
  value = google_compute_vpn_tunnel.vpn_tunnel_rdc.peer_ip
}
