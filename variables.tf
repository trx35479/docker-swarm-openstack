variable "CLUSTER_NAME" {
  default = "dswarm"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "IMAGE_NAME" {
  default = "coreOS"
  #default = "centos7"
}

variable "FLAVOR" {
  default = "m1.small"
}

variable "PUBLIC_NET" {
  default = "public"
}
