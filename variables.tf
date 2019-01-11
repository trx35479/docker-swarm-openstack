variable "CLUSTER_NAME" {
  default = "dswarm"
}

variable "NETWORK_CIDR" {
  default = "10.212.21.0/24"
}

variable "DNS_SERVERS" {
  type    = "list"
  default = ["192.168.11.38", "192.168.11.2", "192.168.0.147"]
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "IMAGE_NAME" {
  default = "coreOS"
}

variable "MAN_FLAVOR" {
  default = "4ab30ff2-a483-4740-b6dc-18abd5366f12"
}

variable "WOR_FLAVOR" {
  default = "4ab30ff2-a483-4740-b6dc-18abd5366f12"
}

variable "NUMBER_OF_WORKERS" {
  default = "2"
}

variable "NUMBER_OF_MANAGER" {
  default = "2"
}

variable "PUBLIC_NET" {
  default = "public"
}
