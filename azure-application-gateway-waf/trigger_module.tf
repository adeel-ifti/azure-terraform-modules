
// Trigger app gateway module to configure 2 backend pools (Grafana and Kibana). 
// Both backend apps are SSL configured for front-end. While only Kibana requires backend HTTPS. Grafana backend isn't configured for SSL hence termination will occur.
// SSL certs are created by Hashi Vault 

// following shell script takes ssl cert issued by your cert-authority and converts to PFX format to be picked up by Elastic Search/Kibana.
data "external" "es-certificate-pfx" {
  program = ["bash", "${path.module}/scripts/generate-pfx.sh"]

  query = {
    certificate = "${module.kibana-appgw-cert.certificate}"
    private_key = "${module.kibana-appgw-cert.private_key}"
    password    = "${random_password.kibana-appgw-ssl.result}"
  }
}

module "dashboard-appgw" {
  source = "./azure-application-gateway-waf"
  prefix              = "${var.prefix}"  
  location            = "${var.location}"
  resource_group_name = "${var.prefix}-rg"
  subnet_id           = "${var.appgw_subnet_id}"
  tags                = "${local.common_tags}"

  waf_configuration   = "${local.waf_configuration}"
  dns_label           = "${local.dns_label}"
  backend_prefix      = "${local.backend_prefix}"
  authentication_certificate = "${module.yourcertprovider.es_kibana_certficate}"

  frontend_ports   = [
    {
      name = "kibana-port"
      port = "443"              
    },
    {
      name = "grafana-port"
      port = "444"
    }
  ]

  frontend_ssl_certificates   = [
    {
      name = "kibana-front-cert"
      certificate = "${data.external.es-certificate-pfx.result["pfx"]}"
      password = "${random_password.kibana-appgw-ssl.result}"
    },
    {
      name = "grafana-front-cert"
      certificate = "${data.external.grafana-certificate-pfx.result["pfx"]}"
      password = "${random_password.grafana-appgw-ssl.result}"
    }
  ]

  backend_address_pools = [
    {
      name = "backend-pool-kibana"
      ip_addresses = ["${var.kibana_loadBalancerIP}"]
    },
    {
      name = "backend-pool-grafana"
      ip_addresses = ["${var.grafana_loadBalancerIP}"]
    }
  ]

  list_http_listener = [
    {
      name                 = "kibana-listener"
      frontend_port_name   = "kibana-port"
      protocol             = "https"
      ssl_front_cert_name  = "kibana-front-cert"
    },
    {
      name                 = "grafana-listener"
      frontend_port_name   = "grafana-port"
      protocol             = "https"
      ssl_front_cert_name  = "grafana-front-cert"
    }
  ]


  backend_http_settings_list = [
    {
      name                  = "http-kibana"
      cookie_based_affinity = "Disabled"
      path                  = ""
      port                  = "5601"
      protocol              = "https"
      request_timeout       = 30

      probe_name = "prob-kibana"
      pick_host_name_from_backend_address = true
      backend_cert_required = true

    },
    {
      name                  = "http-grafana"
      cookie_based_affinity = "Disabled"
      path                  = ""
      port                  = "80"
      protocol              = "http"
      request_timeout       = 30

      probe_name = "prob-grafana"
      pick_host_name_from_backend_address = true
      backend_cert_required = false
    }
  ]

  request_routing_rules = [
    {
      name                          = "kibana-rule"
      rule_type                     = "Basic"
      http_listener_name            = "kibana-listener"
      backend_address_pool_name     = "backend-pool-kibana"
      backend_http_settings_name    = "http-kibana"
    },
     {
      name                          = "grafana-rule"
      rule_type                     = "Basic"
      http_listener_name            = "grafana-listener"
      backend_address_pool_name     = "backend-pool-grafana"
      backend_http_settings_name    = "http-grafana"
    }
  ]

  probes = [
    {
      name         = "prob-kibana"
      protocol     = "https"
      status_code  = ["200","201","202","203","204","205","206","207","208","226","300","301","302","303","304","305","306","307","308"]
    },
    {
      name          = "prob-grafana"
      protocol      = "http"
      status_code   = ["200","201","202","203","204","205","206","207","208","226","300","301","302","303","304","305","306","307","308"]
    }
  ]
  
}