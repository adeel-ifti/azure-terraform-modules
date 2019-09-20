variable "dependencies" {
  type = "list"
  default = []
}

variable "resource_group_name" {
}

variable "location" {
}

variable "prefix" {
}

variable "subnet_id" {
}

variable tags {
  type = "map"
  default = {}
}

variable "waf_configuration" {
  type = "map"
  default = {}
}

variable "dns_label" {  
}

variable "backend_prefix" {
}

variable "frontend_ports" {
 type = "list"
 default     = []
}

variable "backend_address_pools" {
 type = "list"
 default     = []
}

variable "list_http_listener" {
 type = "list"
 default     = []
}

variable "backend_http_settings_list" {
 type = "list"
 default     = []
}

variable "request_routing_rules" {
 type = "list"
 default     = []
}

variable "frontend_ssl_certificates" {
  type = "list"
 default     = []
}

variable "probes" {
 type = "list"
 default = []
}

variable "authentication_certificate" {
  type = "string"
  default = null
}




