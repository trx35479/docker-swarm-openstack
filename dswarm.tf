# Instantiate modules
provider "openstack" {}

module "network" {
  source = "modules/network"

  CLUSTER_NAME = "${var.CLUSTER_NAME}"
  NETWORK_CIDR = "${var.NETWORK_CIDR}"
  PUBLIC_NET   = "${var.PUBLIC_NET}"
  DNS_SERVERS  = "${var.DNS_SERVERS}"
}

module "secgroups" {
  source = "modules/secgroups"

  SEC_NAME = "${var.CLUSTER_NAME}"
}

module "fips" {
  source = "modules/fips"

  PUBLIC_NET        = "${var.PUBLIC_NET}"
  NUMBER_OF_WORKERS = "${var.NUMBER_OF_WORKERS}"
  NUMBER_OF_MANAGER = "${var.NUMBER_OF_MANAGER}"
  ROUTER_ID         = "${module.network.router_id}"
}

module "compute" {
  source = "modules/compute"

  CLUSTER_NAME         = "${var.CLUSTER_NAME}"
  PATH_TO_PUBLIC_KEY   = "${var.PATH_TO_PUBLIC_KEY}"
  IMAGE_NAME           = "${var.IMAGE_NAME}"
  MAN_FLAVOR           = "${var.MAN_FLAVOR}"
  WOR_FLAVOR           = "${var.WOR_FLAVOR}"
  NUMBER_OF_WORKERS    = "${var.NUMBER_OF_WORKERS}"
  NUMBER_OF_MANAGER    = "${var.NUMBER_OF_MANAGER}"
  NETWORK_NAME         = "${module.network.network_name}"
  INT_SEC              = "${module.secgroups.int-secgroup}"
  EXT_SEC              = "${module.secgroups.ext-secgroup}"
  WORKER_FIPS          = "${module.fips.worker_fips}"
  MANAGER_FIPS         = "${module.fips.manager_fips}"
  STANDBY_MANAGER_FIPS = "${module.fips.standby_fips}"
  ROUTER_ID            = "${module.network.router_id}"
  USER_DATA            = "${data.template_file.python.rendered}"
}

output "manager_fip" {
  value = "${module.fips.manager_fips}"
}

output "standby_manager_fips" {
  value = "${module.fips.standby_fips}"
}

output "worker_fips" {
  value = "${module.fips.worker_fips}"
}
