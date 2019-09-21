Azure application gateway provisioning with Kibana & Grafana as backend
--------------------------------------------------------------------------

  - Terraform to provision azure application gateway. 
  - Setup backend pool for Kibana (port: 5601). 
  - Configure front-end SSL cert for Kibana, from Hashi Vault.
  - Hashi Vault cert management for azure application gateway terraform
  - Setup backend pool for Grafana with SSL frontend. 
  - Backend ssl termination, only for Grafana (backend port 80).
  - Access https://<app-gw-dns>:443 for Kibana.
  - Access https://<app-gw-dns>:444 for Kibana.
  - Application gateway with WAF enabled (advanced settings)

Improvements
-------------

  - Path based routing
