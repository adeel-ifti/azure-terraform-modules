# List of regions (support for multi-region deployment)
variable "subnets" {
  description = "List of subnets, multi-region supported"
  type = list(object({
    subnet_name = string
    region      = string
    cidr        = string
    })
  )
  default = [{
    subnet_name = "subnet1"
    region      = "europe-west2"
    cidr        = "10.0.0.0/24"
  }, ]
}

variable "auto_create_subnetworks" {
  type        = bool
  default     = false
  description = "Auto create subnetwork enabled"
}

variable "vpc_name" {
  type        = string
  description = "Name of vpc"
}

variable "private_ip_google_access" {
  type        = bool
  default     = true
  description = "private google ip"
}

variable "region" {
  type        = string
  description = "region of gcp resources"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}
