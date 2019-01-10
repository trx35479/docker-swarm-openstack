variable "CLUSTER_NAME" {}

variable "IMAGE_NAME" {}

variable "PATH_TO_PUBLIC_KEY" {}

variable "NETWORK_NAME" {}

variable "INT_SEC" {}

variable "EXT_SEC" {}

variable "MAN_FLAVOR" {}

variable "WOR_FLAVOR" {}

variable "NUMBER_OF_WORKERS" {}

variable "NUMBER_OF_MANAGER" {}

variable "MANAGER_FIPS" {
  type = "string"
}

variable "STANDBY_MANAGER_FIPS" {
  type = "list"
}

variable "WORKER_FIPS" {
  type = "list"
}

variable "ROUTER_ID" {
  default = ""
}
