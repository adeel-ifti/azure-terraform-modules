variable "dependencies" {
  type = "list"
  default = []
}

variable "resource_group_name" {
}

variable "location" {
  default = "UK South"

}

variable "prefix" {
  default = "gw"

}

variable "subnet_id" {
}

variable tags {
  type = "map"
  default = {}
}

### since these variables are re-used - a locals block makes this more maintainable
###
###

variable "waf_configuration" {
  type = "map"
  default = {
    waf_enabled  = true
    sku_name     = "WAF_Medium"
    sku_tier     = "WAF"
    sku_capacity = "2"
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
    file_upload_limit_mb = "100"
  }
}

variable "dns_label" {  
  default = "my-gw"

}

variable "backend_prefix" {
  default = "gw-backend"

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




