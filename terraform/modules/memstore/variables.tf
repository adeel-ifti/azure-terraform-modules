
variable "region" {
  description = "The GCP region to use."
  type        = string
  default     = null
}

variable "project" {
  description = "The ID of the project in which the resource belongs to."
  type        = string
}

variable "enable_apis" {
  description = "Flag for enabling redis.googleapis.com in your project"
  type        = bool
  default     = true
}

variable "name" {
  description = "The ID of the instance or a fully qualified identifier for the instance."
  type        = string
}

variable "authorized_network" {
  description = "The full name of the Google Compute Engine network to which the instance is connected. If left unspecified, the default network will be used."
  type        = string
  default     = null
}

variable "tier" {
  description = "The service tier of the instance."
  type        = string
}

variable "memory_size_gb" {
  description = "Redis memory size in GiB. Defaulted to 1 GiB"
  type        = number
  default     = 1
}

variable "location_id" {
  description = "The zone where the instance will be provisioned. If not provided, the service will choose a zone for the instance."
  type        = string
  default     = null
}

variable "alternative_location_id" {
  description = "The alternative zone where the instance will be provisioned."
  type        = string
  default     = null
}

variable "redis_version" {
  description = "The version of Redis software."
  type        = string
  default     = null
}

variable "redis_configs" {
  description = "The Redis configuration parameters."
  type        = map(any)
  default     = {}
}

variable "display_name" {
  description = "An arbitrary and optional user-provided name for the instance."
  type        = string
  default     = null
}

variable "reserved_ip_range" {
  description = "The CIDR range of internal addresses that are reserved for this instance."
  type        = string
  default     = null
}

variable "connect_mode" {
  description = "The connection mode of the Redis instance. Can be either DIRECT_PEERING or PRIVATE_SERVICE_ACCESS."
  type        = string
  default     = null
}

variable "labels" {
  description = "The resource labels to represent user provided metadata."
  type        = map(string)
  default     = {}
}

variable "auth_enabled" {
  description = "Indicates whether OSS Redis AUTH is enabled for the instance. If set to true AUTH is enabled on the instance."
  type        = bool
  default     = false
}

variable "transit_encryption_mode" {
  description = "The TLS mode of the Redis instance, If not provided, TLS is enabled for the instance."
  type        = string
  default     = "SERVER_AUTHENTICATION"
}
