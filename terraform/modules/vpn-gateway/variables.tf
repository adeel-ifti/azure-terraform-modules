variable "vpn_name" {
  type        = string
  description = "Name of the new VPN connection"
}

variable "vpn_description" {
  type        = string
  description = "Description of the new VPN connection"
  default     = "Description of the new VPN connection"
}

variable "network_name" {
  type        = string
  description = "Name of vpc"
}

variable "region" {
  type        = string
  description = "region of gcp resources"
}

variable "project_id" {
  type        = string
  description = "The project ID of the resource"
}

variable "vpn_tunnel_name" {
  type        = string
  description = "The vpn_tunnel_nameof the resource"
}

variable "remote_gateway_ip" {
  type        = string
  description = "The remote_gateway_ip of the resource"
}

variable "remote_cidr" {
  type        = list(string)
  description = "The remote_cidr of the resource"
}

variable "vpn_gateway_ip_euw2" {
  type        = string
  description = "The vpn_gateway_ip_euw2 of the resource"
}

variable "local_cidr" {
  type        = list(string)
  description = "The local_cidr of the resource"
}

variable "shared_message" {
  type        = string
  default     = "a secret message"
  description = "The shared_message of the resource"
}

variable "route_priority" {
  type        = number
  description = "vpn route priority"
  default     = 500
}


