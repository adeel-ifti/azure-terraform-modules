variable "subnet_name" {
  type        = string
  description = "Name of subnet"
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

variable "ip_cidr_range" {
  type        = string
  description = "ip cidr range of subnett"
}

variable "ip_pod_range" {
  type        = string
  description = "ip cidr range of subnett"
}

variable "ip_svc_range" {
  type        = string
  description = "ip cidr range of subnett"
}

variable "region" {
  type        = string
  description = "region of gcp resources"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

