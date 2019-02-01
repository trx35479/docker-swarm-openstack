variable "CLUSTER_NAME" {}

variable "SUBNET_ID" {}

variable "VIP_NETWORK" {}

variable "SECURITY_GROUPS" {
  type = "list"
}

variable "COUNT" {}

variable "PROTOCOL" {}

variable "PROTOCOL_PORT" {}

variable "MONITOR_TYPE" {}

variable "NODES" {
  type = "list"
}

variable "ROUTER_ID" {
  default = ""
}
