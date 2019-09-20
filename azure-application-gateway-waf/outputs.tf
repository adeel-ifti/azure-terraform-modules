output "depended_on" {
  value = "${null_resource.dependency_setter.id}"
}

output "appgw_ip_address" {
  value = "${azurerm_public_ip.public-ip.ip_address}"
}

output "appgw_dns_address" {
  value = "${azurerm_public_ip.public-ip.fqdn}"
}