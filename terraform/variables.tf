variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "gke_cluster_name" {
  type = string
}

variable "gke_machine_type" {
  type = string
}

variable "region" {
  type = string
}

variable "gke_initial_node_count" {
  type    = number
  default = 2
}

variable "expiration" {
  description = "TTL of tables using the dataset in MS"
}


variable "time_partitioning" {
  description = "Configures time-based partitioning for this table"
}

variable "dataset_labels" {
  description = "A mapping of labels to assign to the table"
  type        = map(string)
}

variable "dataset_id" {
  description = "A mapping of labels to assign to the table"
  type        = string
}

variable "dataset_name" {
  description = "A mapping of labels to assign to the table"
  type        = string
}

variable "tables" {
  description = "A list of maps that includes both table_id and schema in each element, the table(s) will be created on the single dataset"
  default     = []
  type = list(object({
    table_id = string,
    schema   = string,
    labels   = map(string),
  }))
}

variable "bt_table" {
  description = "Big Table table spec"
}
variable "bt_instance" {
  description = "Big Table instance spec"
}

variable "bt_iam_policy" {
  default = []
}
variable "bt_app_profile" {
  description = "Big Table app profile"
}

variable "redis_name" {
  description = "Name of redis instance"
}

variable "redis_memory_size_gb" {
  description = "Memory Size of redis instance"
}

variable "redis_display_name" {
  description = "Display name of redis instance"
}

variable "redis_labels" {
  description = "Labels applied to redis instance"
}

variable "redis_version" {
  description = "Version to redis instance"
}

variable "redis_tier" {
  description = "Version to redis instance"
}