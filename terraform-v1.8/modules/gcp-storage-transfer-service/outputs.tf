
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

#Azure to GCS variable
variable "azure_storage_account" {
  description = "Azure Storage account"
  type        = string
}

variable "azure_container_name" {
  description = "Azure Container account"
  type        = string
}

variable "azure_file_path" {
  description = "Azure File path"
  type        = string
}

variable "azure_sas_token" {
  description = "Azure SAS Token"
  type        = string
}

variable "azure_to_gcs_bucket_name" {
  description = "Azure to GCS Bucket Name"
  type        = string
}

variable "azure_to_gcs_file_path" {
  description = "Azure to GCS file path"
  type        = string
}