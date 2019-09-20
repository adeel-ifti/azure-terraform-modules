resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

locals {
  appgw_prefix                   = "${var.prefix}-${var.backend_prefix}"
  dns_label                      = "${var.prefix}-${var.dns_label}"
  appgw_name                     = "${local.appgw_prefix}-appgw"
  public_ip_name                 = "${local.appgw_prefix}-pubip"
  gw_ip_config_name              = "${local.appgw_prefix}-gwipcgf"
  frontend_ip_configuration_name = "${local.appgw_prefix}-feip"
  auth_cert                      = "${local.appgw_prefix}-be-cert"
}

resource "azurerm_public_ip" "public-ip" {
  name                = "${local.public_ip_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  allocation_method   = "Dynamic"
  tags                = "${var.tags}"
  domain_name_label   = "${local.dns_label}"
}

resource "azurerm_application_gateway" "app-gateway" {
  name                = "${local.appgw_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tags = "${var.tags}"

  sku {
    name     =  "${var.waf_configuration["sku_name"]}"
    tier     =  "${var.waf_configuration["sku_tier"]}"
    capacity =  "${var.waf_configuration["sku_capacity"]}"
  }

  waf_configuration {
    enabled                 = "${var.waf_configuration["waf_enabled"]}"
    firewall_mode           = "${var.waf_configuration["firewall_mode"]}"
    rule_set_type           = "${var.waf_configuration["rule_set_type"]}"
    rule_set_version        = "${var.waf_configuration["rule_set_version"]}"
    file_upload_limit_mb    = "${var.waf_configuration["file_upload_limit_mb"]}"

    disabled_rule_group {
      rule_group_name = "General"
      rules           = []
    }
  }

  gateway_ip_configuration {
    name      = "${local.gw_ip_config_name}"
    subnet_id = "${var.subnet_id}"
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.public-ip.id}"
  }

 dynamic "frontend_port"  {
    for_each = var.frontend_ports 
     content {
      name     = frontend_port.value.name
      port     = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool"  {
    for_each = var.backend_address_pools 
     content {
      name             = backend_address_pool.value.name
      ip_addresses     = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "authentication_certificate" {
    for_each = compact([var.authentication_certificate])
    content {
      name = "${local.auth_cert}"
      data = "${var.authentication_certificate}"
    }
  }

 dynamic "ssl_certificate"  {
    for_each = var.frontend_ssl_certificates 
     content {
      name           = ssl_certificate.value.name
      data           = ssl_certificate.value.certificate
      password       = ssl_certificate.value.password
    }
  }

  dynamic "backend_http_settings"  {
    for_each = var.backend_http_settings_list 
     content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      path                  = backend_http_settings.value.path
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
      probe_name            = backend_http_settings.value.probe_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address

      dynamic "authentication_certificate" {
        for_each = backend_http_settings.value.backend_cert_required ? ["kibana-cert"] : []
        content {
          name = "${local.auth_cert}"
        }
      }
    }
  }

  dynamic "http_listener"  {
    for_each = var.list_http_listener 
     content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      ssl_certificate_name           = http_listener.value.ssl_front_cert_name
    }
  }

  dynamic "request_routing_rule"  {
    for_each = var.request_routing_rules 
     content {
      name                          = request_routing_rule.value.name
      rule_type                     = request_routing_rule.value.rule_type
      http_listener_name            = request_routing_rule.value.http_listener_name
      backend_address_pool_name     = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name    = request_routing_rule.value.backend_http_settings_name
    }
  }

  dynamic "probe"  {
    for_each = var.probes 
     content {
      name      = probe.value.name
      pick_host_name_from_backend_http_settings = "true"
      interval  = 30
      path      = "/"
      protocol  = probe.value.protocol
      timeout   = 30
      unhealthy_threshold = 3
      match {
        body              = ""
        status_code       = probe.value.status_code
      }
    }
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = ["azurerm_application_gateway.app-gateway"]
}
