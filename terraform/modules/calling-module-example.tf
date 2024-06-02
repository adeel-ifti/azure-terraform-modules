//// ********** variables.tf **********


variable "project_id" {
  type        = string
  description = "Auto create subnetwork enabled"
}

variable "region" {
  type        = string
  description = "Auto create subnetwork enabled"
}

variable "network_name" {
  type        = string
  description = "Auto create subnetwork enabled"
}

variable "subnets" {
  description = "Auto create subnetwork enabled"
  type = list(object({
    subnet_name = string
    region      = string
    cidr        = string
    })
  )
}


//// ********** vpc and subnets module **********


module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.network_name
  subnets    = var.subnets
  region     = var.region
  project_id = var.project_id
}

# VPN Configuration - RDC 
module "vpn_gateway" {
  source       = "./modules/vpn-gateway"
  vpn_name     = "eq-vpn-dev-1"
  network_name = "projects/ccm-nws-npd-yrb9/global/networks/ccm-nws-npd-cnw"
  region       = "europe-west2"
  project_id   = "ccm-nws-npd-yrb9"

  vpn_tunnel_name     = "eq-rdc-vpn-tunnel-1"
  remote_gateway_ip   = "62.189.83.39"
  vpn_gateway_ip_euw2 = "34.142.85.38"
  remote_cidr         = ["172.16.1.12/32", "192.168.60.148/32"]
  local_cidr          = ["10.150.0.0/28", "10.152.0.0/28", "10.154.0.0/28"]
  route_priority      = 500
}

# VPN Configuration - GS2 
module "vpn_gateway_gs2" {
  source       = "./modules/vpn-gateway"
  vpn_name     = "gs-vpn-dev"
  network_name = "projects/ccm-nws-npd-yrb9/global/networks/ccm-nws-npd-cnw"
  region       = "europe-west1"
  project_id   = "ccm-nws-npd-yrb9"

  vpn_tunnel_name     = "eq-gs2-vpn-tunnel"
  remote_gateway_ip   = "62.189.96.109"
  vpn_gateway_ip_euw2 = "34.79.99.93"
  remote_cidr         = ["172.16.1.12/32", "192.168.60.148/32"]
  local_cidr          = ["10.150.0.0/28", "10.152.0.0/28", "10.154.0.0/28"]
  route_priority      = 400
}




//// ********** terraform.tfvars file **********


project_id   = "ccm-nws-npd-yrb9"
network_name = "ccm-nws-npd-cnw"
region       = "europe-west2"

subnets = [

  # Dev Subnets Ranges
  {
    subnet_name = "ccm-nws-npd-euw2-dev-pxy"
    region      = "europe-west2"
    cidr        = "10.150.0.0/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw2-dev-sva"
    region      = "europe-west2"
    cidr        = "10.150.0.16/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw2-dev-inf"
    region      = "europe-west2"
    cidr        = "10.150.4.0/22"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-dev-pxy"
    region      = "europe-west1"
    cidr        = "10.150.128.0/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-dev-sva"
    region      = "europe-west1"
    cidr        = "10.150.128.16/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-dev-inf"
    region      = "europe-west1"
    cidr        = "10.150.132.0/22"
  },

  # SIT Subnets Ranges
  {
    subnet_name = "ccm-nws-npd-euw2-sit-pxy"
    region      = "europe-west2"
    cidr        = "10.152.0.0/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw2-sit-sva"
    region      = "europe-west2"
    cidr        = "10.152.0.16/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw2-sit-inf"
    region      = "europe-west2"
    cidr        = "10.152.4.0/22"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-sit-pxy"
    region      = "europe-west1"
    cidr        = "10.152.128.0/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-sit-sva"
    region      = "europe-west1"
    cidr        = "10.152.128.16/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-sit-inf"
    region      = "europe-west1"
    cidr        = "10.152.132.0/22"
  },

  # UAT Subnets Ranges
  {
    subnet_name = "ccm-nws-npd-euw2-uat-pxy"
    region      = "europe-west2"
    cidr        = "10.154.0.0/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw2-uat-sva"
    region      = "europe-west2"
    cidr        = "10.154.0.16/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw2-uat-inf"
    region      = "europe-west2"
    cidr        = "10.154.4.0/22"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-uat-pxy"
    region      = "europe-west1"
    cidr        = "10.154.128.0/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-uat-sva"
    region      = "europe-west1"
    cidr        = "10.154.128.16/28"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-uat-inf"
    region      = "europe-west1"
    cidr        = "10.154.132.0/22"
  },

  # INF Subnets Ranges
  {
    subnet_name = "ccm-nws-npd-euw2-ssv-inf"
    region      = "europe-west2"
    cidr        = "10.156.4.0/22"
  },
  {
    subnet_name = "ccm-nws-npd-euw1-ssv-inf"
    region      = "europe-west2"
    cidr        = "10.156.132.0/22"
  },
]

