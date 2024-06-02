variable "bt_instance" {
  type = list(any)
}

variable "bt_table" {
  type = list(any)
}

variable "app_profile" {
  type    = list(any)
  default = []
}

variable "bt_policy" {
  type    = list(any)
  default = []
}

variable "bt_iam_policy" {
  type    = list(any)
  default = []
}
