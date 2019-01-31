variable "CLUSTER_NAME" {}

variable "CLUSTER_ROLE" {}

variable "IMAGE_ID" {}

variable "KEYPAIR" {}

variable "NETWORK_NAME" {}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "FLAVOR" {}

variable "COUNT" {
  type = "list"
}

variable "FIPS" {
  type = "list"
}

variable "ROUTER_ID" {
  default = ""
}

variable "USER_DATA" {
  default = ""
}
