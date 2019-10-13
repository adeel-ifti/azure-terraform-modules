Azure application gateway provisioning with Kibana & Grafana as backend
--------------------------------------------------------------------------

  - Terraform to provision azure application gateway. 
  - Setup backend pool for Kibana over SSL(port: 5601). 
  - Configure front-end SSL cert for Kibana, CSR request to Hashi Vault PKI.
  - Hashi Vault cert management for azure application gateway via terraform.
  - Setup backend pool for Grafana (not ssl) over port 80. 
  - Set up front-end SSL for Grafana, CSR request to Hashi Vault PKI.
  - Access https://app-gw-dns:443 for Kibana.
  - Access https://app-gw-dns:444 for Kibana.
  - Application gateway with WAF enabled (advanced settings)

Future Improvements
-------------

  - Path based routing
